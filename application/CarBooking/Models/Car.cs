namespace CarBooking.Models
{
    public class Car
    {
        public int CarID { get; set; }
        public string Model { get; set; }
        public string Brand { get; set; }
        public decimal PricePerDay { get; set; }
        public bool Availability { get; set; }
    }
}