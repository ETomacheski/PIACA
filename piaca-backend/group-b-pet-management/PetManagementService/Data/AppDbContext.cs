using Microsoft.EntityFrameworkCore;
using PetManagementService.Models;

namespace PetManagementService.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
        {
        }

        public DbSet<Pet> Pets => Set<Pet>();
        public DbSet<Image> Images => Set<Image>();
        public DbSet<PetDisease> PetDiseases => Set<PetDisease>();
        public DbSet<PetTemperament> PetTemperaments => Set<PetTemperament>();
        public DbSet<PetSociability> PetSociabilities => Set<PetSociability>();
        public DbSet<VeterinaryCare> VeterinaryCares => Set<VeterinaryCare>();
        public DbSet<PetDetails> PetDetails => Set<PetDetails>();
        public DbSet<Occurrence> Occurrences => Set<Occurrence>();
        public DbSet<Attachment> Attachments => Set<Attachment>();

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<Pet>(entity =>
            {
                entity.ToTable("pets");
                entity.HasKey(e => e.Id);

                entity.Property(e => e.Id).HasColumnName("id");
                entity.Property(e => e.NgoId).HasColumnName("ngo_id");
                entity.Property(e => e.ProtectorId).HasColumnName("protector_id");
                entity.Property(e => e.Status).HasColumnName("status");
                entity.Property(e => e.Species).HasColumnName("species");
                entity.Property(e => e.Name).HasColumnName("name");
                entity.Property(e => e.Age).HasColumnName("age");
                entity.Property(e => e.BirthDate).HasColumnName("birth_date");
                entity.Property(e => e.IdLink).HasColumnName("link_id");
                entity.Property(e => e.Gender).HasColumnName("gender");
                entity.Property(e => e.Description).HasColumnName("description");
                entity.Property(e => e.City).HasColumnName("city");
                entity.Property(e => e.State).HasColumnName("state");

                entity.Property(e => e.Gender).HasColumnType("char(1)");
                entity.Property(e => e.Age).HasColumnType("varchar");
                entity.Property(e => e.IdLink).HasColumnType("varchar");
            });

            modelBuilder.Entity<Image>(entity =>
            {
                entity.ToTable("images");
                entity.HasKey(e => e.Id);

                entity.Property(e => e.Id).HasColumnName("id");
                entity.Property(e => e.FileName).HasColumnName("file_name");
                entity.Property(e => e.S3Url).HasColumnName("s3_url");
                entity.Property(e => e.PetId).HasColumnName("pet_id");

                entity.HasOne(e => e.Pet)
                    .WithMany(p => p.Images)
                    .HasForeignKey(e => e.PetId);
            });

            modelBuilder.Entity<PetDisease>(entity =>
            {
                entity.ToTable("pet_diseases");
                entity.HasKey(e => e.Id);

                entity.Property(e => e.Id).HasColumnName("id");
                entity.Property(e => e.PetId).HasColumnName("pet_id");
                entity.Property(e => e.Name).HasColumnName("name");

                entity.HasOne(e => e.Pet)
                    .WithMany(p => p.Diseases)
                    .HasForeignKey(e => e.PetId);
            });

            modelBuilder.Entity<PetTemperament>(entity =>
            {
                entity.ToTable("pet_temperament");
                entity.HasKey(e => e.Id);

                entity.Property(e => e.Id).HasColumnName("id");
                entity.Property(e => e.PetId).HasColumnName("pet_id");
                entity.Property(e => e.Type).HasColumnName("type");

                entity.HasOne(e => e.Pet)
                    .WithMany(p => p.Temperaments)
                    .HasForeignKey(e => e.PetId);
            });

            modelBuilder.Entity<PetSociability>(entity =>
            {
                entity.ToTable("pet_sociability");
                entity.HasKey(e => e.Id);

                entity.Property(e => e.Id).HasColumnName("id");
                entity.Property(e => e.PetId).HasColumnName("pet_id");
                entity.Property(e => e.Title).HasColumnName("title");

                entity.HasOne(e => e.Pet)
                    .WithMany(p => p.Sociabilities)
                    .HasForeignKey(e => e.PetId);
            });

            modelBuilder.Entity<VeterinaryCare>(entity =>
            {
                entity.ToTable("veterinary_care");
                entity.HasKey(e => e.Id);

                entity.Property(e => e.Id).HasColumnName("id");
                entity.Property(e => e.PetId).HasColumnName("pet_id");
                entity.Property(e => e.Type).HasColumnName("type");

                entity.HasOne(e => e.Pet)
                    .WithMany(p => p.VeterinaryCares)
                    .HasForeignKey(e => e.PetId);
            });

            modelBuilder.Entity<PetDetails>(entity =>
            {
                entity.ToTable("pet_details");
                entity.HasKey(e => e.Id);

                entity.Property(e => e.Id).HasColumnName("id");
                entity.Property(e => e.PetId).HasColumnName("pet_id");
                entity.Property(e => e.Breed).HasColumnName("breed");
                entity.Property(e => e.Size).HasColumnName("size");
                entity.Property(e => e.Weight).HasColumnName("weight");
                entity.Property(e => e.Coat).HasColumnName("coat");
                entity.Property(e => e.Color).HasColumnName("color");
                entity.Property(e => e.Reactivity).HasColumnName("reactivity");
                entity.Property(e => e.Microchip).HasColumnName("microchip");

                entity.HasOne(e => e.Pet)
                    .WithOne(p => p.Details)
                    .HasForeignKey<PetDetails>(e => e.PetId);
            });

            modelBuilder.Entity<Occurrence>(entity =>
            {
                entity.ToTable("occurrences");
                entity.HasKey(e => e.Id);

                entity.Property(e => e.Id).HasColumnName("id");
                entity.Property(e => e.PetId).HasColumnName("pet_id");
                entity.Property(e => e.Type).HasColumnName("type");
                entity.Property(e => e.Title).HasColumnName("title");
                entity.Property(e => e.Date).HasColumnName("date");
                entity.Property(e => e.Description).HasColumnName("description");

                entity.HasOne(e => e.Pet)
                    .WithMany(p => p.Occurrences)
                    .HasForeignKey(e => e.PetId);
            });

            modelBuilder.Entity<Attachment>(entity =>
            {
                entity.ToTable("attachments");
                entity.HasKey(e => e.Id);

                entity.Property(e => e.Id).HasColumnName("id");
                entity.Property(e => e.OccurrenceId).HasColumnName("occurrence_id");
                entity.Property(e => e.FileName).HasColumnName("file_name");
                entity.Property(e => e.S3Url).HasColumnName("s3_url");

                entity.HasOne(e => e.Occurrence)
                    .WithMany(o => o.Attachments)
                    .HasForeignKey(e => e.OccurrenceId);
            });
        }
    }
}