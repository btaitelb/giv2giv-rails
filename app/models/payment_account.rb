require 'dwolla'

class PaymentAccount < Neo4j::Rails::Model
  class PaymentException < Exception; end
  class AccountInvalid < PaymentException; end
  class DonorInvalid < PaymentException; end

  property :processor # dwolla, paypal, etc
  property :token # do other payment processors use token?
  property :pin # dwolla requires us to know the donor's pin
  property :requires_reauth # should be false unless a payment fails

  has_one(:donor).from(Donor, :payment_account)

  validates :requires_reauth, :inclusion => {:in => [false]}
  validates :processor, :presence => true
  validates :token, :presence => true
  validates :donor, :presence => true
  before_validation :set_requires_reauth, :on => :create

  def set_requires_reauth
    # just being nice for create
    self.requires_reauth = false if !self.requires_reauth
    true
  end

  # for one time donation
  def donate(amount, charity_group_id)
    raise AccountInvalid if !self.valid?

    Dwolla::token = token
    transaction_id = Dwolla::Transactions.send({:destinationId => App.dwolla['account_id'],
                                                :amount => amount.to_f,
                                                :pin => pin})

    # should amount be after processing fee(s)? seems like no
    donation = donor.donations.build(:amount => amount,
                                     :charity_group_id => charity_group_id,
                                     :transaction_id => transaction_id,
                                     :transaction_processor => processor)
    donation.save(false)
    donation
  end

end