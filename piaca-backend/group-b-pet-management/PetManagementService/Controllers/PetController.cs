using Microsoft.AspNetCore.Mvc;
using PetManagementService.Models;
using PetManagementService.Services;

namespace PetManagementService.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class PetController : ControllerBase
    {
        private readonly IPetService _petService;

        public PetController(IPetService petService)
        {
            _petService = petService;
        }

        [HttpGet("getAllPets")]
        public async Task<ActionResult<List<Pet>>> GetAllPets()
        {
            var pets = await _petService.GetAllPetsAsync();
            return Ok(pets);
        }

        [HttpGet("getPet")]
        public async Task<ActionResult<List<Pet>>> GetSinglePets(Guid petId)
        {
            if (petId == Guid.Empty)
            {
                return BadRequest("A pet id must be provided");
            }
            var pet = await _petService.GetSinglePetAsync(petId);
            return Ok(pet);
        }
    }
}