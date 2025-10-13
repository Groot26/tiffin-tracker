# 🥗 Tiffin Tracker App

A simple yet powerful Flutter app to **track your daily tiffin (Veg/Non-Veg) consumption** and calculate your **monthly expenses** automatically — inspired by GitHub’s contribution chart design.

---

## 📱 Overview

Instead of manually noting down your meals every day, **Tiffin Tracker** lets you record them with a single tap.  
Each day is color-coded based on your meal type:

- 🟩 **Veg (₹80)**
- 🟥 **Non-Veg (₹100)**
- ⬜ **No Tiffin**

At the end of the month, the app automatically shows you:

✔️ Number of Veg days  
✔️ Number of Non-Veg days  
✔️ Total Tiffin Days  
✔️ Total Monthly Expense

---

## 🧠 Features

- 📅 Dynamic calendar view for each month
- ⚡ Quick selection via bottom sheet (Veg / Non-Veg / Clear)
- 🔁 Reactive state management using **GetX**
- 💾 Persistent local data storage
- 💰 Auto-calculated monthly totals
- 🎨 Clean, minimal Material UI inspired by GitHub contribution charts

---

## 🛠️ Tech Stack

| Tool / Package | Purpose |
|----------------|----------|
| **Flutter** | Cross-platform UI framework |
| **GetX** | State management & reactive UI updates |
| **Flutter Material UI** | Building clean and fast user interfaces |
| **DateTime Utilities** | Dynamic calendar generation |
| **Local Storage (Custom Service)** | Save and load tiffin data persistently |

---