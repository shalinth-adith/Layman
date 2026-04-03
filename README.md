# Layman — Business, Tech & Startups Made Simple

![Layman App] 
<img width="399" height="874" alt="Screenshot 2026-04-03 at 11 53 07 AM" src="https://github.com/user-attachments/assets/bd497485-0995-4de1-8896-9f8ff9d54e94" />


A simplified news reader for business, tech, and startups. 
Layman takes complex news and presents it in plain everyday 
language — in layman's terms.

---

## Screenshots

| Welcome | Home | Article | Ask Layman |
|---------|------|---------|------------|
<img width="399" height="874" alt="Screenshot 2026-04-03 at 11 53 07 AM" src="https://github.com/user-attachments/assets/9f968c57-fa07-41ea-b797-70ddda1195d7" />
<img width="399" height="874" alt="Screenshot 2026-04-03 at 11 53 15 AM" src="https://github.com/user-attachments/assets/198c0bc9-3c7b-4918-a189-9b4799582f83" />
<img width="399" height="874" alt="Screenshot 2026-04-03 at 11 53 56 AM" src="https://github.com/user-attachments/assets/30f6c561-7dc0-4b0e-99fe-e5afe9c3b82a" />
<img width="399" height="874" alt="Screenshot 2026-04-03 at 11 54 19 AM" src="https://github.com/user-attachments/assets/84e63f7d-89f2-496d-9c68-b1ac2bd0960a" />
<img width="399" height="874" alt="Screenshot 2026-04-03 at 11 54 31 AM" src="https://github.com/user-attachments/assets/daf8f7a6-22a2-44bb-9c67-88230c4cd2aa" />
<img width="399" height="874" alt="Screenshot 2026-04-03 at 11 56 03 AM" src="https://github.com/user-attachments/assets/f1456812-12d1-44e1-ae77-75bac6bd77dd" />

---

## Features

- Warm onboarding with swipe-to-start gesture
- Email and password auth powered by Supabase
- Real news articles from NewsData.io API
- Horizontal swipeable article carousel
- Article detail with 3 swipeable content cards in simple language
- AI chatbot (Ask Layman) powered by Groq llama3-8b-8192
- Context-aware chatbot — answers questions about the article you're reading
- Auto-generated question suggestions for each article
- Save and bookmark articles synced to Supabase
- Search across articles
- Clean MVVM architecture
- API keys secured via .xcconfig

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| UI | SwiftUI |
| Architecture | MVVM |
| Auth + Database | Supabase |
| News API | NewsData.io |
| AI Chatbot | Groq (llama3-8b-8192) |
| Session Management | Supabase Auth |

---

## Project Structure
```
Layman/
├── Models/
│   └── Article.swift
├── ViewModels/
│   └── HomeViewModel.swift
├── Views/
│   ├── WelcomeView.swift
│   ├── AuthView.swift
│   ├── HomeView.swift
│   ├── ArticleDetailView.swift
│   ├── AskLaymanView.swift
│   ├── SavedView.swift
│   └── ProfileView.swift
├── Services/
│   ├── NewsService.swift
│   ├── SupabaseService.swift
│   └── GroqService.swift
└── Utilities/
    └── Constants.swift
```

---

## Setup Instructions

### Prerequisites
- Xcode 15 or later
- iOS 17 or later
- A Supabase account
- A NewsData.io account
- A Groq account

### Step 1 — Clone the repo
```bash
git clone https://github.com/yourusername/Layman.git
cd Layman
```

### Step 2 — Add Supabase Swift Package
In Xcode:
- File → Add Package Dependencies
- Paste: `https://github.com/supabase/supabase-swift`
- Add to Layman target

### Step 3 — Configure API Keys
Create a file called `Config.xcconfig` in the project root:
```
SUPABASE_URL = your_supabase_project_url
SUPABASE_ANON_KEY = your_supabase_anon_key
NEWSDATA_API_KEY = your_newsdata_api_key
GROQ_API_KEY = your_groq_api_key
```

Then in Xcode:
- Click project name in navigator
- Info tab
- Set Debug and Release configuration to `Config`

### Step 4 — Set up Supabase

Run this SQL in your Supabase SQL editor:
```sql
create table saved_articles (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users not null,
  article_id text not null,
  title text,
  image_url text,
  source_url text,
  created_at timestamp default now()
);

alter table saved_articles enable row level security;

create policy "Users own their saves"
on saved_articles for all
using (auth.uid() = user_id);
```

### Step 5 — Run the app
- Select your simulator or device
- Press `Cmd + R`

---

## Environment Variables

| Variable | Where to get it |
|----------|----------------|
| `SUPABASE_URL` | Supabase dashboard → Settings → API |
| `SUPABASE_ANON_KEY` | Supabase dashboard → Settings → API |
| `NEWSDATA_API_KEY` | newsdata.io → Dashboard |
| `GROQ_API_KEY` | console.groq.com → API Keys |

---

## AI Workflow

This project was built using **Claude Code** as the 
primary AI coding assistant.

### Tools Used
- Claude Code (terminal)
- Xcode 15

### How I used Claude Code
- Started every session with `/init` to load project context
- Used specific, scoped prompts per feature
- Iterated on errors by pasting Xcode errors directly into Claude
- Used `/review` before every commit
- Used `/commit` after every screen

### Prompt Strategy
Instead of vague prompts like "build the home screen",
I used specific prompts like:
```
Build HomeView with a paged TabView carousel showing 
AsyncImage with dark gradient overlay at bottom, 
headline text on image, page indicator dots, and a 
Today's Picks vertical list below using HomeViewModel.
Match color palette from CLAUDE.md.
```
---

## CLAUDE.md
See `CLAUDE.md` in the repo root for the full project 
context file used to guide Claude Code throughout 
development.

---

## Screens

1. **Welcome** — Gradient background, swipe to start
2. **Auth** — Email/password login and signup
3. **Home** — Article carousel and Today's Picks
4. **Article Detail** — 3 swipeable content cards
5. **Ask Layman** — AI chatbot with suggestions
6. **Saved** — Bookmarked articles
7. **Profile** — User info and sign out

---

## Security

- All API keys stored in `Config.xcconfig`
- `Config.xcconfig` is in `.gitignore`
- Supabase Row Level Security enabled
- Users can only read and write their own data

---

## Contact

Built by Shalinth Adithyan
Linkedn - https://www.linkedin.com/in/shalinth-adithyan/
Mail ID - shalinth.adith@outlook.com
