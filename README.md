# 🥗 Grain & Gain

> Empowering Students, Supporting Restaurants — A task-based meal reward platform aligned with UN SDGs **(No Poverty & Zero Hunger).**

---

## 🌍 Inspiration

Many students struggle to afford proper meals, while local restaurants often have unused resources and limited ways to engage their community.  
**Grain & Gain** bridges this gap — allowing students to earn free or discounted meals by completing small tasks for restaurants.

This initiative directly contributes to:

- **SDG 1: No Poverty**
- **SDG 2: Zero Hunger**

---

## 🚀 What It Does

**Grain & Gain** is a digital platform that connects **students** and **restaurants** through a task-based reward ecosystem.

### 👩‍🍳 For Restaurants:
- Create and manage community or promotional tasks  
- Review student applications and submissions  
- Approve proofs and credit reward points  
- Validate redemption codes for meal claims  

### 🎓 For Students:
- Browse and apply for restaurant tasks  
- Submit proofs (images or external links)  
- Earn reward points after approval  
- Redeem meal points at partner restaurants  

### 🔢 Reward Formula (with LaTeX support):

$$
\text{Total Points} = \sum_{i=1}^{n} (\text{Reward Points per Approved Task}_i)
$$

---

## 🛠️ How We Built It

| Component | Technology Used |
|------------|----------------|
| **Frontend** | Flutter (Dart) |
| **State Management** | GetX |
| **Backend / Cloud** | Supabase (PostgreSQL, Auth, Storage) |
| **Architecture** | MVC (Model-View-Controller) |
| **Version Control** | GitHub |
| **IDE** |  VS Code |

---

## ⚙️ Features

✅ Role-based authentication (Student / Restaurant)  
✅ Task management and approval workflow  
✅ Proof submission with images or links  
✅ Wallet system with reward points  
✅ Meal redemption with 6-digit validation codes  
✅ Real-time updates using reactive GetX observables  

---

## 🧠 Challenges We Faced

- Maintaining **data consistency** between approvals and wallet balance  
- Implementing **secure proof verification** and link submission  
- Synchronizing real-time updates across both dashboards  
- Designing a **smooth UX** for two distinct user roles  

---

## 🏆 Accomplishments We’re Proud Of

- Built a fully functional **two-sided platform** with Flutter and Supabase  
- Designed a **secure and intuitive reward flow**  
- Created a project that aligns with real-world **SDGs impact (No Poverty & Zero Hunger)**  
- Demonstrated how **tech can be used for social good**  

---

## 📚 What We Learned

- Effective use of **GetX for reactive state management**  
- Secure **Supabase integration** (Auth, DB, Storage)  
- Building scalable architectures for multi-role systems  
- Real-time data synchronization and wallet point management  

---

## 🔮 What’s Next for Grain & Gain

- Introduce **AI-based task recommendations**  
- Add **leaderboards and gamification** for engagement  
- Expand to **university-level partnerships**  
- Implement **multi-currency meal redemption** options  
- Integrate **push notifications** for task updates  

---

## 🧩 Tech Stack Summary

**Languages:** Dart  
**Frameworks:** Flutter, GetX  
**Backend & Cloud:** Supabase (PostgreSQL, Auth, Storage)  
**Architecture:** MVC
**Tools:** GitHub, VS Code  
**Platforms:** Android & iOS  

---

## 🧾 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

> **"Technology that feeds hope — one grain at a time."**
