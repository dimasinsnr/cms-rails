class Lead < ApplicationRecord
  belongs_to :user
  belongs_to :product, optional: true
  validates :status, inclusion: { in: ['draf', 'waiting', 'approved', 'rejected'] }

  # Pastikan callback ini dipanggil setelah status berubah menjadi 'approved'
  after_update :convert_to_customer, if: -> { status_changed? && status == 'approved' }

  private

  def convert_to_customer
    # Jika produk ada, ambil ID produk, jika tidak, set nil
    product_id_value = product.present? ? product.id : nil

    # Membuat Customer baru dengan data dari Lead
    Customer.create(
      name: name, 
      email: email, 
      phone: phone, 
      product_id: product_id_value
    )
  end
end