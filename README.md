# Gym App (Flutter + Node.js)

A complete Gym Management System featuring Role-Based Access Control (RBAC), Program Building, and Workout Tracking.

## 🚀 Features
- **Admin**: Manage users and assign roles.
- **Coach**: Create complex workout programs (Weeks/Days) and assign them to athletes.
- **User**: View assigned programs and log workout sessions (Sets, Reps, RPE).

## 📂 Project Structure
- `gym-backend/`: Node.js, Express, Mongoose backend.
- `gym_app-master/`: Flutter mobile application.
- `db/`: Seed data for the database.

## 🔑 Default Credentials
**Global Password:** `password123`

| Role | Email | Name | Description |
| :--- | :--- | :--- | :--- |
| **Admin** | `admin@gym.com` | Admin User | Full system access. |
| **Coach** | `coach@gym.com` | Coach Carter | Can create programs & view athlete logs. |
| **User** | `user@gym.com` | John Doe | Assigned to Coach Carter. |

## 🛠️ Setup Instructions

### 1. Backend
1. Navigate to `gym-backend`:
   ```bash
   cd gym-backend
   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. Start the server (runs on port 3000):
   ```bash
   npm run dev
   ```

### 2. Frontend (Flutter)
1. Navigate to `gym_app-master`:
   ```bash
   cd gym_app-master
   ```
2. Get packages:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

## 📝 Tech Stack
- **Frontend**: Flutter, Provider
- **Backend**: Node.js, Express.js, TypeScript
- **Database**: MongoDB (Mongoose)
- **Auth**: JWT (JSON Web Tokens)
