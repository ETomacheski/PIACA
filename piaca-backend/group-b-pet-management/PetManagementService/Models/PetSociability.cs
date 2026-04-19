namespace PetManagementService.Models
{
    public class PetSociability
    {
        public Guid Id { get; set; }
        public Guid PetId { get; set; }
        public string? Title { get; set; }

        public Pet Pet { get; set; } = null!;
    }
}