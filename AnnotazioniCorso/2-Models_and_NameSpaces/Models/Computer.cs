namespace HelloWorld.Models{
    public class Computer
    {
        // Motherboard is a 'propery' that gets and sets the corresponding 'field' _motherboard
        public string Motherboard { get; set; }
        public int CPUCores { get; set; }
        public bool HasWifi { get; set; }
        public bool HasLTE { get; set; }
        public DateTime ReleaseDate { get; set; }
        public decimal Price { get; set; }
        public string VideoCard { get; set; }

        public Computer() // 'constructor': make sure every instance of the class respects the type
        {
            if (VideoCard == null)
                VideoCard = "";
            if (Motherboard == null)
                Motherboard = "";
        }
    }
}