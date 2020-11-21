﻿using System;
using CharlieBackend.Core;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using CharlieBackend.Core.DTO.Student;
using Microsoft.AspNetCore.Authorization;
using CharlieBackend.Core.Models.ResultModel;
using CharlieBackend.Business.Services.Interfaces;
using Swashbuckle.AspNetCore.Annotations;
using CharlieBackend.Api.SwaggerExamples.StudentsController;

namespace CharlieBackend.Api.Controllers
{
    /// <summary>
    /// Controller to manage students
    /// </summary>
    [Route("api/students")]
    [ApiController]
    public class StudentsController : ControllerBase
    {
        #region
        private readonly IStudentService _studentService;
        private readonly IAccountService _accountService;
        #endregion
        /// <summary>
        /// Students Controllers constructor
        /// </summary>
        public StudentsController(IStudentService studentService, 
            IAccountService accountService)
        {
            _studentService = studentService;
            _accountService = accountService;
        }

        /// <summary>
        /// Addition of new student
        /// </summary>
        /// <response code="200">Successful assing of account into student</response>
        /// <response code="HTTP: 404, API: 3">Error, can not find account</response>
        /// <response code="HTTP: 400, API: 0">Error, account already assigned</response>
        [SwaggerResponse(200, type: typeof(StudentDto))]
        [Authorize(Roles = "Admin, Secretary")]
        [HttpPost("{accountId}")]
        public async Task<ActionResult> PostStudent(long accountId)
        {
            var createdStudentModel = await _studentService
                    .CreateStudentAsync(accountId);

            return createdStudentModel.ToActionResult();
        }

        /// <summary>
        /// Get student information by student id
        /// </summary>
        /// <response code="200">Successful return of student</response>
        /// <response code="409">Error, can not find student</response>
        [SwaggerResponse(200, type: typeof(StudentMock))]
        [Authorize(Roles = "Admin, Mentor, Secretary")]
        [HttpGet("{id}")]
        public async Task<ActionResult<List<StudentDto>>> GetStudentById(long id)
        {

            var studentModel = await _studentService.GetStudentByIdAsync(id);

            if (studentModel != null)
            {
                return Ok(new
                {
                    first_name = studentModel.FirstName,
                    last_name = studentModel.LastName,
                    //student_group_ids = studentModel.StudentGroupIds, // TODO fix
                    email = studentModel.Email
                });
            }

            return StatusCode(409, "Cannot find student with such id.");
        }

        /// <summary>
        /// Get all students
        /// </summary>
        /// <response code="200">Successful return of students list</response>
        [SwaggerResponse(200, type: typeof(IList<StudentDto>))]
        [Authorize(Roles = "Admin, Mentor, Secretary")]
        [HttpGet]
        public async Task<ActionResult<List<StudentDto>>> GetAllStudents()
        {

            var studentsModels = await _studentService.GetAllStudentsAsync();

            return Ok(studentsModels);

        }

        /// <summary>
        /// Updates student
        /// </summary>
        /// <response code="200">Successful update of student</response>
        /// <response code="HTTP: 404, API: 3">Error, can not find student</response>
        /// <response code="HTTP: 400, API: 0">Error, update data is wrong</response>
        [SwaggerResponse(200, type: typeof(UpdateStudentDto))]
        [Authorize(Roles = "Admin, Mentor, Secretary")]
        [HttpPut("{studentId}")]
        public async Task<ActionResult> PutStudent(long studentId, [FromBody]UpdateStudentDto studentModel)
        {
            var updatedStudent = await _studentService.UpdateStudentAsync(studentId, studentModel);

            return updatedStudent.ToActionResult();
        }

        /// <summary>
        /// Disabling of student
        /// </summary>
        /// <response code="204">Successful update of student</response>
        /// <response code="400">Error, student not found</response>
        [Authorize(Roles = "Admin, Mentor, Secretary")]
        [HttpDelete("{id}")]
        public async Task<ActionResult> DisableStudent(long id)
        {

            var accountId = await _studentService.GetAccountId(id);

            if (accountId == null)
            {
                return BadRequest("Unknown student id.");
            }

            var isDisabled = await _accountService
                    .DisableAccountAsync((long)accountId);

            if (isDisabled)
            {
                return NoContent();
            }

            return StatusCode(500, "Error occurred while trying to disable student account.");
        }
    }
}
