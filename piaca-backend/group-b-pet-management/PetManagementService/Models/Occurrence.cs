namespace PetManagementService.Models
{
    public class Occurrence
    {
        public Guid Id { get; set; }
        public Guid PetId { get; set; }

        public string? Type { get; set; }
        public string? Title { get; set; }
        public DateTime? Date { get; set; }
        public string? Description { get; set; }

        public Pet Pet { get; set; } = null!;
        public List<Attachment> Attachments { get; set; } = new();
    }
}