# Data Model

## ER Diagram

The following diagram shows the main entities and their relationships. Arrows point from the table containing the FK to the referenced table.

```
┌─────────────────────────────────────────────────────────────────────────┐
│                          USERS AND ROLES                               │
│                                                                        │
│  ┌──────────┐    ┌──────────────┐    ┌──────────┐                      │
│  │ app_role │◄───│app_user_role │───►│ app_user │                      │
│  └──────────┘    └──────────────┘    └─────┬────┘                      │
│                                            │                           │
│                       ┌────────────────────┼──────────────────┐        │
│                       │                    │                  │        │
│                       ▼                    ▼                  ▼        │
│              ┌─────────────────┐  ┌────────────────┐  ┌────────────┐  │
│              │ teacher_profile │  │student_profile │  │notification│  │
│              └────────┬────────┘  └───────┬────────┘  │_preference │  │
│                       │                   │           └────────────┘  │
│                       ▼                   ▼                           │
│              ┌──────────────┐     ┌────────────┐                      │
│              │teacher_class │────►│ user_class │                      │
│              └──────────────┘     └────────────┘                      │
└─────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────┐
│                     ASSESSMENT (mutable templates)                     │
│                                                                        │
│  ┌────────────┐    ┌──────────┐    ┌────────┐                          │
│  │ assessment │───►│ question │───►│ option │                          │
│  └─────┬──────┘    └────┬─────┘    └────────┘                          │
│        │                │                                              │
│        ▼                ▼                                              │
│  ┌─────────────┐  ┌──────────────┐    ┌─────────┐                     │
│  │ assessment  │  │question_     │───►│ subject │                     │
│  │ _subject    │  │ subject      │    └────┬────┘                     │
│  └─────────────┘  └──────────────┘         │                          │
│                                            │                          │
│  ┌───────┐    ┌───────────────┐             │                          │
│  │ topic │───►│ topic_subject │─────────────┘                          │
│  └───────┘    └───────────────┘                                        │
└─────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────┐
│                     SNAPSHOT (immutable copies)                         │
│                                                                        │
│  ┌───────────────────┐    ┌───────────────────┐    ┌────────────────┐  │
│  │assessment_snapshot│───►│question_snapshot  │───►│option_snapshot │  │
│  └────────┬──────────┘    └────────┬──────────┘    └────────────────┘  │
│           │                        │                                   │
│           ▼                        ▼                                   │
│  ┌────────────────┐    ┌─────────────────────────┐                     │
│  │class_assessment│    │question_snapshot_subject│                     │
│  └───────┬────────┘    └─────────────────────────┘                     │
│          │                                                             │
│          ▼                                                             │
│  ┌────────────┐                                                        │
│  │ user_class │                                                        │
│  └────────────┘                                                        │
└─────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────┐
│                          SUBMISSION                                    │
│                                                                        │
│  ┌────────────┐    ┌─────────────┐    ┌──────────────────────────────┐ │
│  │ submission │───►│ user_answer │───►│user_answer_selected_option  │ │
│  └────────────┘    └─────────────┘    └──────────────────────────────┘ │
│        │                  │                         │                  │
│        │ FK               │ FK                      │ FK               │
│        ▼                  ▼                         ▼                  │
│  assessment_snapshot  question_snapshot       option_snapshot          │
└─────────────────────────────────────────────────────────────────────────┘
```

## Relational Model

Below is the complete relational model. Each table lists: columns, type, constraints and keys.

Conventions:

- **PK** = Primary Key
- **FK** = Foreign Key
- **UQ** = Unique
- **NN** = Not Null
- All tables include `created_at` and `updated_at` (TIMESTAMP, managed by the DB).

### Users and Roles

**app_user**

| Column | Type | Constraints |
|--------|------|-------------|
| `id` | UUID | PK |
| `name` | VARCHAR | NN |
| `username` | VARCHAR | NN, UQ |
| `password_hash` | VARCHAR | NN |
| `email` | VARCHAR | UQ |
| `must_change_password` | BOOLEAN | NN, default false |
| `password_expires_at` | TIMESTAMP | |

Example:

| id | name | username | email | must_change_password |
|----|------|----------|-------|---------------------|
| `a1b2...` | Alice Rossi | `a.rossi` | alice@example.com | false |
| `c3d4...` | Demo Teacher | `teacher` | NULL | false |

---

**app_role**

| Column | Type | Constraints |
|--------|------|-------------|
| `id` | UUID | PK, auto |
| `name` | VARCHAR | NN, UQ |

Values: `ADMIN`, `TEACHER`, `STUDENT`.

---

**app_user_role** (M:N association)

| Column | Type | Constraints |
|--------|------|-------------|
| `user_id` | UUID | PK, FK → app_user |
| `role_id` | UUID | PK, FK → app_role |

Example:

| user_id | role_id |
|---------|---------|
| `a1b2...` (Alice) | `r001...` (STUDENT) |
| `c3d4...` (Teacher) | `r002...` (TEACHER) |

---

**user_class**

| Column | Type | Constraints |
|--------|------|-------------|
| `id` | UUID | PK |
| `name` | VARCHAR | NN |

Example: `{ id: "cl01...", name: "SW-2026" }`

---

**student_profile**

| Column | Type | Constraints |
|--------|------|-------------|
| `id` | UUID | PK, auto |
| `user_id` | UUID | NN, UQ, FK → app_user |
| `class_id` | UUID | NN, FK → user_class |

Example: `{ user_id: "a1b2..." (Alice), class_id: "cl01..." (SW-2026) }`

---

**teacher_profile**

| Column | Type | Constraints |
|--------|------|-------------|
| `id` | UUID | PK, auto |
| `user_id` | UUID | NN, UQ, FK → app_user |

---

**teacher_class** (M:N association)

| Column | Type | Constraints |
|--------|------|-------------|
| `user_id` | UUID | PK, FK → app_user |
| `class_id` | UUID | PK, FK → user_class |

---

**notification_preference**

| Column | Type | Constraints |
|--------|------|-------------|
| `id` | UUID | PK, auto |
| `user_id` | UUID | NN, FK → app_user |
| `type` | VARCHAR(50) | NN, enum |
| `enabled` | BOOLEAN | NN |

Values for `type`: `EXAM_RESULT`, `DEADLINE_REMINDER`, `PRODUCT_NEWS`.

Example:

| user_id | type | enabled |
|---------|------|---------|
| `a1b2...` (Alice) | EXAM_RESULT | true |
| `a1b2...` (Alice) | DEADLINE_REMINDER | false |

---

### Assessment (mutable templates)

**assessment** (physical table: `test`)

| Column | Type | Constraints |
|--------|------|-------------|
| `id` | UUID | PK |
| `title` | VARCHAR | NN |
| `date` | DATE | NN |
| `timer_minutes` | INT | NN |
| `total_pool` | INT | NN |
| `questions_per_test` | INT | NN |
| `pts_correct` | DECIMAL | NN |
| `pts_wrong` | DECIMAL | NN |
| `difficulty` | VARCHAR(20) | enum, nullable |
| `type` | VARCHAR(20) | NN, default CERTIFICATION |
| `passing_score` | DECIMAL | |

Values for `difficulty`: `BEGINNER`, `INTERMEDIATE`, `ADVANCED`, `EXPERT`.

Values for `type`: `CERTIFICATION`, `TRAINING`.

Example:

| id | title | difficulty | type |
|----|-------|------------|------|
| `t01...` | Computer Networks | INTERMEDIATE | CERTIFICATION |
| `t02...` | Databases — Training | BEGINNER | TRAINING |

Details for `t01`: timer 30 min, pool 50, questions per test 20, +1.00/−0.25 points.

---

**question**

| Column | Type | Constraints |
|--------|------|-------------|
| `id` | UUID | PK |
| `test_id` | UUID | NN, FK → assessment |
| `type` | VARCHAR | NN |
| `text` | TEXT | NN |
| `code` | TEXT | |
| `explanation` | TEXT | |
| `position` | INT | NN |
| `points` | DECIMAL(5,2) | |
| `difficulty` | VARCHAR(20) | enum, nullable |

Example:

- `q01`: MULTIPLE_CHOICE, "Which protocol operates at OSI layer 4?", difficulty INTERMEDIATE, assessment `t01`, position 1, default points.
- `q02`: MULTIPLE_CHOICE, "What does ls -la return?", difficulty BEGINNER, assessment `t01`, position 2, points 2.00, code `ls -la /home`.

---

**option**

| Column | Type | Constraints |
|--------|------|-------------|
| `id` | UUID | PK |
| `question_id` | UUID | NN, FK → question |
| `text` | VARCHAR | NN |
| `is_correct` | BOOLEAN | NN |
| `is_fallback` | BOOLEAN | NN |
| `position` | INT | NN |

Example (for question q01):

| id | text | is_correct | is_fallback |
|----|------|------------|-------------|
| `o01...` | TCP | true | false |
| `o02...` | HTTP | false | false |
| `o03...` | ARP | false | false |
| `o04...` | None of the above | false | true |

---

**subject**

| Column | Type | Constraints |
|--------|------|-------------|
| `id` | UUID | PK |
| `label` | VARCHAR | NN |

Example: `{ id: "s01...", label: "OSI Model" }`, `{ id: "s02...", label: "Linux Commands" }`

---

**question_subject** (M:N association with weight)

| Column | Type | Constraints |
|--------|------|-------------|
| `question_id` | UUID | PK, FK → question |
| `subject_id` | UUID | PK, FK → subject |
| `weight` | DECIMAL(5,2) | NN, default 1.00 |

Example:

| question_id | subject_id | weight |
|-------------|------------|--------|
| `q01...` (Layer 4 protocol) | `s01...` (OSI Model) | 1.00 |
| `q02...` (ls -la) | `s02...` (Linux Commands) | 1.00 |

---

**assessment_subject** (physical table: `test_subject`, M:N association)

| Column | Type | Constraints |
|--------|------|-------------|
| `test_id` | UUID | PK, FK → assessment |
| `subject_id` | UUID | PK, FK → subject |

---

**topic**

| Column | Type | Constraints |
|--------|------|-------------|
| `id` | UUID | PK, auto |
| `title` | VARCHAR(200) | NN |
| `description` | TEXT | |
| `abbreviation` | VARCHAR(4) | |
| `position` | INT | |
| `enabled` | BOOLEAN | NN, default true |

Example: `{ title: "Computer Networks", abbreviation: "NETS", position: 1, enabled: true }`

---

**topic_subject** (M:N association)

| Column | Type | Constraints |
|--------|------|-------------|
| `topic_id` | UUID | PK, FK → topic |
| `subject_id` | UUID | PK, FK → subject |
| `position` | INT | |

---

### Snapshot (immutable copies)

The snapshot mechanism ensures that submissions always reference a frozen version of the assessment. Publishing creates immutable copies of the assessment, questions, options and question-subject relationships.

**assessment_snapshot**

| Column | Type | Constraints |
|--------|------|-------------|
| `id` | UUID | PK, auto |
| `assessment_id` | UUID | FK → assessment, nullable |
| `content_hash` | VARCHAR(64) | NN |
| `version` | INT | NN |
| `title` | VARCHAR | NN |
| `timer_minutes` | INT | NN |
| `questions_per_assessment` | INT | NN |
| `pts_correct` | DECIMAL | NN |
| `pts_wrong` | DECIMAL | NN |
| `difficulty` | VARCHAR(20) | enum, nullable |
| `type` | VARCHAR(20) | NN, default CERTIFICATION |
| `passing_score` | DECIMAL | |
| `published_at` | TIMESTAMP | NN |

`assessment_id` is nullable to allow dynamically generated training sessions without a parent assessment.

Example:

| id | assessment_id | version | title |
|----|---------------|---------|-------|
| `snap01...` | `t01...` | 1 | Computer Networks |
| `snap02...` | NULL | 1 | Training — OSI Model |

`snap01`: published 2026-06-10 09:00. `snap02`: training session without parent assessment.

---

**question_snapshot**

| Column | Type | Constraints |
|--------|------|-------------|
| `id` | UUID | PK, auto |
| `assessment_snapshot_id` | UUID | NN, FK → assessment_snapshot |
| `original_question_id` | UUID | FK → question, nullable |
| `type` | VARCHAR | NN |
| `text` | TEXT | NN |
| `code` | TEXT | |
| `explanation` | TEXT | |
| `position` | INT | NN |
| `points` | DECIMAL(5,2) | |

---

**option_snapshot**

| Column | Type | Constraints |
|--------|------|-------------|
| `id` | UUID | PK, auto |
| `question_snapshot_id` | UUID | NN, FK → question_snapshot |
| `original_option_id` | UUID | FK → option, nullable |
| `text` | VARCHAR | NN |
| `is_correct` | BOOLEAN | NN |
| `is_fallback` | BOOLEAN | NN |
| `position` | INT | NN |

---

**question_snapshot_subject** (M:N association with weight)

| Column | Type | Constraints |
|--------|------|-------------|
| `question_snapshot_id` | UUID | PK, FK → question_snapshot |
| `subject_id` | UUID | PK, FK → subject |
| `weight` | DECIMAL(5,2) | NN, default 1.00 |

---

**class_assessment** (physical table: `class_test`)

| Column | Type | Constraints |
|--------|------|-------------|
| `class_id` | UUID | PK, FK → user_class |
| `assessment_snapshot_id` | UUID | PK, FK → assessment_snapshot |
| `activated_at` | TIMESTAMP | |
| `deactivated_at` | TIMESTAMP | |

Example:

| class_id | assessment_snapshot_id | activated_at | deactivated_at |
|----------|----------------------|--------------|----------------|
| `cl01...` (SW-2026) | `snap01...` | 2026-06-10 09:00 | NULL |

---

### Submission

**submission**

| Column | Type | Constraints |
|--------|------|-------------|
| `id` | UUID | PK, auto |
| `user_id` | UUID | NN, FK → app_user |
| `assessment_snapshot_id` | UUID | NN, FK → assessment_snapshot |
| `status` | VARCHAR | NN, default IN_PROGRESS |
| `started_at` | TIMESTAMP | |
| `submitted_at` | TIMESTAMP | |
| `score` | DOUBLE | |

Values for `status`: `IN_PROGRESS`, `SUBMITTED`, `AUTO_CLOSED`.

Example:

| id | user_id | status | score |
|----|---------|--------|-------|
| `sub01...` | `a1b2...` (Alice) | SUBMITTED | 16.50 |
| `sub02...` | `a1b2...` (Alice) | AUTO_CLOSED | 12.00 |

Both reference snapshot `snap01`. `sub01`: started 09:05, submitted 09:28. `sub02`: started 10:00, auto-closed 10:30.

---

**user_answer**

| Column | Type | Constraints |
|--------|------|-------------|
| `id` | UUID | PK, auto |
| `submission_id` | UUID | NN, FK → submission |
| `question_snapshot_id` | UUID | NN, FK → question_snapshot |
| `type` | VARCHAR | NN |
| `text` | TEXT | |
| `motivation` | TEXT | |
| `flagged` | BOOLEAN | NN |
| `is_correct` | BOOLEAN | |
| `points_awarded` | DOUBLE | |

Example:

| id | type | flagged | is_correct | points_awarded |
|----|------|---------|------------|----------------|
| `ans01...` | MULTIPLE_CHOICE | false | true | 1.00 |
| `ans02...` | MULTIPLE_CHOICE | true | false | -0.25 |

Both belong to submission `sub01`.

---

**user_answer_selected_option**

| Column | Type | Constraints |
|--------|------|-------------|
| `id` | UUID | PK, auto |
| `answer_id` | UUID | NN, FK → user_answer |
| `option_snapshot_id` | UUID | NN, FK → option_snapshot |

UNIQUE constraint on `(answer_id, option_snapshot_id)`.

Example:

| id | answer_id | option_snapshot_id |
|----|-----------|-------------------|
| `sel01...` | `ans01...` | `os01...` (TCP — correct) |
| `sel02...` | `ans02...` | `os05...` (HTTP — wrong) |

---

## Enumerations

- **AssessmentType**: `CERTIFICATION`, `TRAINING` — used in assessment, assessment_snapshot.
- **Difficulty**: `BEGINNER`, `INTERMEDIATE`, `ADVANCED`, `EXPERT` — used in assessment, assessment_snapshot, question.
- **SubmissionStatus**: `IN_PROGRESS`, `SUBMITTED`, `AUTO_CLOSED` — used in submission.
- **NotificationType**: `EXAM_RESULT`, `DEADLINE_REMINDER`, `PRODUCT_NEWS` — used in notification_preference.

## Assessment Lifecycle

An assessment goes through several phases from creation to administration. There is no explicit status field: the lifecycle is determined by the presence of snapshots and activation dates.

```
                                    per class
  ┌──────────┐    ┌─────────────┐    ┌───────────┐    ┌──────────────┐
  │ Created  │───►│  Published  │───►│  Active   │───►│ Deactivated  │
  │ (draft)  │    │ (snapshot)  │    │(per class) │   │ (per class)  │
  └──────────┘    └─────────────┘    └───────────┘    └──────────────┘
       │                                    │
       │ editable                           │ students can
       │ by teacher                         │ take the assessment
       ▼                                    ▼
  new publication                  ongoing submissions
  = new snapshot                      reference the
  (next version)                     active snapshot
```

| Phase | Description |
|-------|-------------|
| Created | The assessment exists as a draft editable by the teacher |
| Published | An immutable snapshot has been generated. If the content has not changed since the last publication, the existing snapshot is reused |
| Active | The snapshot has been assigned to a class (activation date set). Students in that class can take the assessment |
| Deactivated | The assessment has been removed from the class (deactivation date set). Students no longer see it, but completed submissions remain in history |

The teacher can modify an assessment and republish it at any time: this generates a new snapshot version without affecting submissions already in progress or completed on the previous version.

## Submission States

```
            ┌─────────────┐
   start    │ IN_PROGRESS │
──────────► │             │
            └──────┬──────┘
                   │
         ┌────────┴────────┐
         │                 │
   manual submit      timer expiry
         │                 │
         ▼                 ▼
 ┌───────────┐     ┌─────────────┐
 │ SUBMITTED │     │ AUTO_CLOSED │
 └───────────┘     └─────────────┘
```

| Status | Meaning |
|--------|---------|
| IN_PROGRESS | The student has started but not yet submitted |
| SUBMITTED | The student submitted manually |
| AUTO_CLOSED | The system closed the submission when the timer expired |

## Design Notes

- **Immutable snapshots**: at publication time, assessments, questions, options and question-subject relationships are copied to separate tables. Submissions always reference snapshots, never templates. This ensures that subsequent changes to the template do not alter data from assessments already administered.
- **Nullable `assessment_id`**: snapshots generated by training mode have no parent assessment, as they are created dynamically by aggregating questions from multiple assessments.
- **`is_fallback`**: options with this flag (e.g. "None of the above") are always placed last during shuffle, regardless of randomization.
- **`weight` in question-subject relationship**: enables per-subject score breakdown in the results screen.
- **Per-question `points`**: when set, overrides the assessment-level score (`pts_correct`). The maximum score (`max_score`) is computed as the sum of points for the selected questions.
- **`content_hash`**: SHA-256 hash of the assessment content. If the content has not changed since the last publication, the existing snapshot is reused.

\newpage
