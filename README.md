# Quotely – Random Quote Generator

Flutter app built for the **CodeAlpha App Development Internship (Task 2)**.

## Features
- Random quote on every app launch
- **New Quote** button, never repeats the current quote
- Quote text and author displayed clearly
- Category filter (Motivation, Wisdom, Life, Technology)
- Save favorites (persisted locally), swipe to delete
- Copy quote to clipboard
- Light / Dark / System theme
- Clean, minimal Material 3 UI

## Screens
Splash · Home · Favorites · Settings

## Tech Stack
Flutter · Dart · Provider · shared_preferences · google_fonts

## Run Locally
    git clone https://github.com/YOUR_USERNAME/CodeAlpha_RandomQuoteGenerator.git
    cd CodeAlpha_RandomQuoteGenerator
    flutter pub get
    flutter run

## Test
    flutter test

## Project Structure
    lib/
      data/        quote model + dataset
      providers/   QuoteProvider, ThemeProvider
      screens/     splash, home, favorites, settings, shell
      theme/       Material 3 themes
      widgets/     reusable QuoteCard

## Author
Mahir Ahamed Rohan