namespace PetManagementService.Models
{
    public class PetDetails
    {
        public Guid Id { get; set; }
        public Guid PetId { get; set; }

        public string? Breed { get; set; }
        public string? Size { get; set; }
        public float? Weight { get; set; }
        public string? Coat { get; set; }
        public string? Color { get; set; }
        public string? Reactivity { get; set; }
        public bool? Microchip { get; set; }

        public Pet Pet { get; set; } = null!;
    }
}