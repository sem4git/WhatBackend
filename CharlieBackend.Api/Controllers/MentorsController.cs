﻿using CharlieBackend.Business.Services.Interfaces;
using CharlieBackend.Core.Models;
using CharlieBackend.Core.Models.Mentor;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace CharlieBackend.Api.Controllers
{
    [Route("api/mentor")]
    [ApiController]
    public class MentorsController : ControllerBase
    {
        private readonly IMentorService _mentorService;
        private readonly IAccountService _accountService;

        public MentorsController(IMentorService mentorService, IAccountService accountService)
        {
            _mentorService = mentorService;
            _accountService = accountService;
        }

        [HttpPost]
        public async Task<ActionResult> PostMentor(CreateMentorModel mentorModel)
        {
            if (!ModelState.IsValid) return BadRequest();

            var isEmailTaken = await _accountService.IsEmailTakenAsync(mentorModel.Email);
            if (isEmailTaken) return StatusCode(409, "Account already exists!");

            var createdMentorModel = await _mentorService.CreateMentorAsync(mentorModel);
            if (createdMentorModel == null) return StatusCode(422, "Invalid courses.");

            return Ok();
        }

        [HttpGet]
        public async Task<ActionResult<List<MentorModel>>> GetAllMentors()
        {
            try
            {
                var mentosModels = await _mentorService.GetAllMentorsAsync();
                return Ok(mentosModels);
            }
            catch { return StatusCode(500); }
        }
    }
}