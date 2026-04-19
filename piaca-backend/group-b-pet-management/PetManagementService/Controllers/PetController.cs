using Microsoft.AspNetCore.Mvc;
using PetManagementService.Models;
using PetManagementService.Services;

namespace PetManagementService.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class PetsController : ControllerBase
    {
        private readonly IPetService _petService;

        public PetsController(IPetService petService)
        {
            _petService = petService;
        }

        [HttpGet]
        public async Task<ActionResult<List<Pet>>> GetAll()
        {
            var pets = await _petService.GetAllAsync();
            return Ok(pets);
        }
    }
}