namespace PetManagementService.Models
{
    public class Image
    {
        public Guid Id { get; set; }
        public string? FileName { get; set; }
        public string? S3Url { get; set; }

        public Guid? PetId { get; set; }
        public Pet? Pet { get; set; }
    }
}