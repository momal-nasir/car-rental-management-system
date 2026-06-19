using System;

namespace CarBooking.Models
{
    public class Payment
    {
        public int PaymentID { get; set; }
        public int BookingID { get; set; }
        public decimal RentAmount { get; set; }
        public decimal SecurityFee { get; set; }
        public decimal TotalPaid { get; set; }
        public DateTime PaymentDate { get; set; }
    }
}