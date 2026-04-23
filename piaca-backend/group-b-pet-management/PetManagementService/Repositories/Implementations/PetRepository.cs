using Microsoft.EntityFrameworkCore;
using PetManagementService.Data;
using PetManagementService.Models;

namespace PetManagementService.Repositories
{
    public class PetRepository : IPetRepository
    {
        private readonly AppDbContext _context;

        public PetRepository(AppDbContext context)
        {
            _context = context;
        }

        public async Task<List<Pet>> GetAllPetsAsync()
        {
            return await _context.Pets
                .AsNoTracking()
                .ToListAsync();
        }

        public async Task<Pet?> GetSinglePetAsync(Guid petId)
        {
            return await _context.Pets
                .AsNoTracking()
                .FirstOrDefaultAsync(p => p.Id == petId);
        }

        public async Task<PetDetails?> GetPetDetailsAsync(Guid petId)
        {
            return await _context.PetDetails
                .AsNoTracking()
                .FirstOrDefaultAsync(d => d.PetId == petId);
        }

        // public async Task<Pet> CreatePet()
        // {
            
        // }
    }
}