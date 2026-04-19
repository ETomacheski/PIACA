namespace PetManagementService.Models
{
    public class Attachment
    {
        public Guid Id { get; set; }
        public Guid OccurrenceId { get; set; }

        public string? FileName { get; set; }
        public string? S3Url { get; set; }

        public Occurrence Occurrence { get; set; } = null!;
    }
}