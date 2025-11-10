# Vibe Circle
Flutter internship assignment: Onboarding Questionnaire for Hotspot Hosts.  
The application collects the user's preferred experience types and their motivation to host, through text input, audio recording, or video recording.

---

## Project Structure

├─ lib/  
│  ├─ core/  
│  │  ├─ constants.dart  
│  │  ├─ di.dart  
│  │  ├─ routers/app_router.dart  
│  │  └─ theme/  
│  │     ├─ app_colors.dart  
│  │     ├─ text_styles.dart  
│  │     └─ theme.dart  
│  ├─ data/  
│  │  ├─ models/experience.dart  
│  │  ├─ services/api_client.dart  
│  │  └─ repositories/experience_repository.dart  
│  ├─ features/  
│  │  ├─ experience_select/  
│  │  │  ├─ bloc/ (ExperienceBloc, Events, State)  
│  │  │  ├─ view/experience_screen.dart  
│  │  │  └─ widgets/experience_card.dart, multi_line_field.dart  
│  │  └─ onboarding_question/  
│  │     ├─ bloc/ (QuestionBloc, Events, State)  
│  │     ├─ view/question_screen.dart  
│  │     └─ widgets/audio_recorder.dart, video_recorder.dart  
│  └─ main.dart  
└─ assets/icons/

---

## Start Screen Module

**Purpose**  
Entry point of the onboarding flow. Introduces the process.

**Key Points**
- Soft glowing animated background.
- Fade-in UI animation.
- Clear CTA button (“Start”).

**Navigation**
- `StartScreen → ExperienceScreen` via `Navigator.push`.

---

## Experience Selection Module

**Purpose**  
User selects the category of experiences they want to host and optionally describes their concept.

**Data Model**
- `Experience` model parsed from API response.

**Repository**
- `ExperienceRepository.fetch()` retrieves and maps API data.

**State Management**
- Managed via `ExperienceBloc`.

**Events**
- `ExperienceRequested` → Load data.
- `ToggleExperience(id)` → Select/Deselect.
- `NoteChanged(note)` → Update descriptive text.

**UI Behavior**
- Horizontal list + optional grid view ("See all").
- Multi-line text field with **250 character limit**.
- Cards use **grayscale when unselected**.
- Selected cards visually reorder toward front.
- "Next" button enabled if:
    - At least one card selected OR
    - Description text is not empty.

**Navigation**
- `ExperienceScreen → QuestionScreen` using `AppRouter.question`.

---

## Onboarding Question Module

**Purpose**  
Collects a longer response on why the user wants to host, using **text, audio, or video**.

**State Management**
- `QuestionBloc` holds:
    - `text` (up to 600 characters)
    - `audio` file (optional)
    - `video` file (optional)

**Events**
- `QuestionTextChanged(text)`
- `QuestionAttachAudio(file)`
- `QuestionAttachVideo(file)`
- `QuestionDeleteAudio()`
- `QuestionDeleteVideo()`

**UI Features**
- Multi-line text field with **600 character limit**.
- Option to **record audio**:
    - Uses `record` package.
    - Live animated **waveform** while recording.
    - Timer + Cancel / Done actions.
- Option to **record video**:
    - Uses camera via `image_picker`.
    - Stores file locally for delete support.

**Playback**
- Audio: play/pause + **waveform visualization**.
- Video: fullscreen playback using `video_player`.

**Navigation**
- On Next → Navigate back to StartScreen with:
