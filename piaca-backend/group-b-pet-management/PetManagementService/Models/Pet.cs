namespace PetManagementService.Models
{
    public class Pet
    {
        public Guid Id { get; set; }

        public Guid? NgoId { get; set; }
        public Guid? ProtectorId { get; set; }

        public int Status { get; set; }
        public string? Species { get; set; }
        public string? Name { get; set; }
        public string? Age { get; set; }
        public DateTime? BirthDate { get; set; }
        public string? IdLink { get; set; }
        public char Gender { get; set; }
        public string? Description { get; set; }
        public string? City { get; set; }
        public string? State { get; set; }

        public PetDetails? Details { get; set; }

        public List<Image> Images { get; set; } = new();
        public List<PetDisease> Diseases { get; set; } = new();
        public List<PetTemperament> Temperaments { get; set; } = new();
        public List<PetSociability> Sociabilities { get; set; } = new();
        public List<VeterinaryCare> VeterinaryCares { get; set; } = new();
        public List<Occurrence> Occurrences { get; set; } = new();
    }
}