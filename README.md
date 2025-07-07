To: Lead Automation Engineer
From: Project 1: Adaptive Cruise Control
Date: July 7, 2025
Subject: Final Project Report with Mathematical Formulation

### **1.0 System Analysis**
This report details the design and evolution of a complete Adaptive Cruise Control (ACC) system, from initial dynamic modeling to a final implementation using Model Predictive Control (MPC).

---
#### **1.1 Vehicle Dynamics Model**
The foundation of the project is a longitudinal vehicle dynamics model. The net force on the vehicle dictates its acceleration according to Newton's second law:
$$m \cdot a_x = F_{prop} - F_{brake} - F_{resist}$$
Where the total resistive force ($F_{resist}$) is the sum of rolling resistance and aerodynamic drag:

* **Rolling Resistance ($F_{roll}$):**
    $$F_{roll} = C_{rr} \cdot m \cdot g$$
* **Aerodynamic Drag ($F_{aero}$):**
    $$F_{aero} = 0.5 \cdot \rho \cdot C_d \cdot A \cdot V_{ego}^2$$

---
### **2.0 Control System Evolution**
The control strategy evolved through several stages to meet performance requirements.

#### **2.1 Initial Approach: PID Speed Controller**
The initial controller was a standard PID designed to track a driver-set speed ($V_{set}$). To systematically tune this controller, the non-linear vehicle model was linearized around a nominal operating speed, resulting in a first-order transfer function that described the vehicle's acceleration dynamics. While this allowed for systematic tuning, the resulting fixed-gain controller performed poorly outside of its specific design-point velocity.

#### **2.2 Hierarchical State-Based Controller**
To handle multiple driving scenarios, a hierarchical architecture was developed using Stateflow. This high-level controller determines the operational mode (`NoTarget` or `Following`) and outputs the primary control objective: the **desired acceleration (`a_des_final`)**.
* In `NoTarget` mode, `a_des_final` is calculated to achieve the driver's set speed.
* In `Following` mode, `a_des_final` is calculated to maintain a safe following distance based on the time-gap policy:
    $$D_{des} = D_{standstill} + T_{gap} \cdot V_{ego}$$

#### **2.3 Final Controller: MPC Mathematical Formulation**
To robustly track the `a_des_final` command while respecting physical limits, the low-level PID was replaced with a Model Predictive Controller (MPC). The MPC's objective is to calculate the optimal propulsion force ($F_{prop}$) at each time step. This is achieved by solving a constrained optimization problem based on a predictive model.

* **Prediction Model**: The controller uses a discrete-time state-space model to predict future acceleration:
    $$a_x(k+1) = A \cdot a_x(k) + B \cdot F_{prop}(k)$$
    Where $k$ is the current time step, $a_x$ is the vehicle's actual acceleration, and $A, B$ are matrices derived from the linearized physical model.

* **Optimization Problem**: At each time step `k`, the MPC calculates the optimal sequence of future force commands by minimizing a cost function `J`. This function balances tracking performance against passenger comfort (minimizing jerk).
    $$\min_{F_{prop}} J(k) = \sum_{i=1}^{N_p} w_{accel} (a_{x,pred}(k+i) - a_{des\_final}(k+i))^2 + \sum_{i=0}^{N_c-1} w_{jerk} (\Delta F_{prop}(k+i))^2$$
    Where:
    * $(a_{x,pred} - a_{des\_final})^2$ is the squared **tracking error** for acceleration.
    * $(\Delta F_{prop})^2$ is the squared **change in force**, which penalizes jerk.
    * $w_{accel}$ and $w_{jerk}$ are the tuning weights that define the trade-off between performance and comfort.
    This minimization is performed subject to the vehicle's physical **constraints**:
    * $0 \le F_{prop} \le F_{max}$
    * $a_{min} \le a_x \le a_{max}$
    * $\Delta F_{min} \le \Delta F_{prop} \le \Delta F_{max}$

* **Receding Horizon Principle**: The controller calculates the optimal plan over the future horizon but only implements the **very first force command**, $F_{prop}(k)$. At the next time step, it measures the new vehicle state and repeats the entire optimization to generate a new, updated plan. This makes the controller robust to real-world disturbances.

---
### **3.0 Conclusion**
The final system architecture, a high-level Stateflow controller providing a reference to a low-level MPC, is robust, high-performing, and correctly models the advanced control strategies used in modern automotive applications. It successfully balances the logical complexity of mode-switching with the mathematical rigor of constrained, optimal control.
