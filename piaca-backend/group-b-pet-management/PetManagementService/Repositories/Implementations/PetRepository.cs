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

        public async Task<List<Pet>> GetAllAsync()
        {
            return await _context.Pets
                .AsNoTracking()
                .ToListAsync();
        }
    }
}