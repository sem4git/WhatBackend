﻿using System;
using System.Collections.Generic;

namespace CharlieBackend.Core.Entities
{
    public partial class Mentor : BaseEntity
    {
        public Mentor()
        {
            Lessons = new HashSet<Lesson>();
            MentorsOfCourses = new HashSet<MentorOfCourse>();
            MentorsOfStudentGroups = new HashSet<MentorOfStudentGroup>();
        }

        public long? AccountId { get; set; }

        public virtual Account Account { get; set; }
        public virtual ICollection<Lesson> Lessons { get; set; }
        public virtual ICollection<MentorOfCourse> MentorsOfCourses { get; set; }
        public virtual ICollection<MentorOfStudentGroup> MentorsOfStudentGroups { get; set; }
    }
}
