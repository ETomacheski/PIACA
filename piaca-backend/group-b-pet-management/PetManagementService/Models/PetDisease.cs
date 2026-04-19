namespace PetManagementService.Models
{
    public class PetDisease
    {
        public Guid Id { get; set; }
        public Guid PetId { get; set; }
        public string? Name { get; set; }

        public Pet Pet { get; set; } = null!;
    }
}