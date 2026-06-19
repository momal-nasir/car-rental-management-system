using System;

namespace CarBooking.Models
{
    public class Return
    {
        public int ReturnID { get; set; }
        public int BookingID { get; set; }
        public DateTime ReturnDate { get; set; }
        public bool DamageStatus { get; set; }
        public decimal RefundAmount { get; set; }
        public string Remarks { get; set; }
    }
}