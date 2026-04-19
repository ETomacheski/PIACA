namespace PetManagementService.Models
{
    public class VeterinaryCare
    {
        public Guid Id { get; set; }
        public Guid PetId { get; set; }
        public string? Type { get; set; }

        public Pet Pet { get; set; } = null!;
    }
}