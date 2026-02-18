/* ============================================================
   PROJECT: GAMING ADDICTION BUSINESS SQL ANALYSIS
   DATASET: mhgames
   PURPOSE: Stakeholder, behavioral, health & revenue insights
   AUTHOR: Aakash 
   NOTES: This file contains all analysis questions as SQL comments.
          Each question includes a detailed purpose describing
          stakeholders, decision uses, and expected actions.
   ============================================================ */

/* ============================================================
   Q1
   ============================================================
   What percentage of gamers fall into each addiction risk level?

   Purpose:
   Quantify the size of each risk cohort (Low / Moderate / High / Severe).
   Stakeholders: Executives, Public Health teams, Product Safety.
   Why it matters: Provides baseline prevalence of addiction severity,
   which is a foundational KPI for resource allocation, public messaging,
   product moderation and potential regulatory scrutiny.
   How to use: If Severe or High > threshold (e.g., 15-20%), prioritize
   intervention programs, content warnings, and consider product changes;
   track this metric over time (weekly/monthly) to measure impact.
*/

SELECT
    gaming_addiction_risk_level,
    COUNT(*) AS gamer_count,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM mhgames
GROUP BY gaming_addiction_risk_level
ORDER BY percentage DESC;



/* ============================================================
   Q2
   ============================================================
   What is the global average daily gaming time?

   Purpose:
   Calculate mean daily gaming hours across the dataset to measure
   overall engagement intensity. Stakeholders: Strategy, UX, Health
   Researchers. Why it matters: Average hours is a high-level signal
   of platform engagement and potential behavioral risk. How to use:
   Use as a benchmark for cohort comparisons (by age, platform, genre),
   and to set thresholds for "heavy use" segments in downstream analyses.
*/

select round(avg(daily_gaming_hours)::numeric,2) as Global_average,COUNT(*) AS total_gamers from mhgames;




/* ============================================================
   Q3
   ============================================================
   What percentage of gamers sleep less than 6 hours per day?

   Purpose:
   Estimate prevalence of short sleepers (sleep < 6 hrs), which is a
   common health risk indicator associated with excessive gaming.
   Stakeholders: Health policy researchers, Student affairs, HR.
   Why it matters: High proportion indicates population-level sleep
   deprivation linked to gaming — may trigger awareness campaigns,
   sleep hygiene interventions, or research studies. How to use:
   Cross-tab with gaming hours and risk level to identify high-impact groups.
*/




SELECT 
    CONCAT(
        ROUND(
            COUNT(*) FILTER (WHERE sleep_hours < 6) * 100.0 / COUNT(*)::numeric, 
            2
        ), 
        '%'
    ) AS sleep_less6 
FROM mhgames;


/* ============================================================
   Q4
   ============================================================
   What is the average monthly game spending per gamer?

   Purpose:
   Measure monetization per user (ARPU) from in-game purchases and
   game-related spending. Stakeholders: Finance, Product, Marketing.
   Why it matters: Reveals revenue health and helps segment whales,
   casual spenders, and medium-tier spenders. How to use: Drive marketing
   segmentation, LTV modelling and price experiments; check correlation with
   addiction risk to evaluate ethical concerns and revenue dependency.
*/



SELECT
    ROUND(AVG(monthly_game_spending_usd)::numeric, 2)
        AS avg_monthly_spending_per_gamer,
    SUM(monthly_game_spending_usd)
        AS total_revenue,
    COUNT(*) AS total_gamers
FROM mhgames;




/* ============================================================
   Q5
   ============================================================
   What is the student vs working professional split?
   (Derived using presence of grades_gpa vs work_productivity_score)

   Purpose:
   Create a derived population split to understand life-stage exposure
   to gaming. Stakeholders: Universities, HR, Product. Why it matters:
   Students and working professionals have different schedules, risk
   tolerance and policy requirements; interventions for students (e.g.
   campus programs) differ from workplace wellness programs. How to use:
   Use this segmentation for tailored messaging, and compare risk/impact
   metrics (GPA vs productivity) to recommend targeted policies.
*/

SELECT
    user_occupation_type,
    COUNT(*) AS total_count,
    concat(
    ROUND(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER(),
        2
    ) ,'%')AS percentage
FROM mhgames
GROUP BY user_occupation_type
ORDER BY percentage DESC;


/* ============================================================
   Q6
   ============================================================
   What is the average social isolation score globally?

   Purpose:
   Provide a population-level metric for social withdrawal linked to gaming.
   Stakeholders: Mental health teams, Community managers, Researchers.
   Why it matters: High isolation suggests social health impacts and
   potential for prioritized outreach. How to use: Monitor trends by segment
   and combine with face-to-face hours to build social reengagement strategies.
*/

select round(avg(social_isolation_score),2) as isolation_score_globally , COUNT(*) AS total_gamers from mhgames;



/* ============================================================
   Q7
   ============================================================
   What is the average sleep duration across all gamers?

   Purpose:
   Establish a sleep health benchmark for the population. Stakeholders:
   Health research, Product safety, Education. Why it matters: Helps
   quantify the sleep deficit vs recommended norms and compare across cohorts.
   How to use: Use to create health alerts and to stratify risk by age, genre.
*/

select avg(sleep_hours) as sleep_duration_all from mhgames;



/* ============================================================
   Q8
   ============================================================
   Average monthly spending by addiction risk level.

   Purpose:
   Determine whether higher addiction severity translates into higher
   monetization. Stakeholders: Finance, Compliance, Product. Why it matters:
   If severe/high risk segments yield disproportionate revenue, this raises
   ethical and regulatory questions and informs pricing/monetization strategy.
   How to use: Use results to evaluate responsible monetization policies,
   consider spending caps or nudges for high-risk users.
*/


SELECT 
    gaming_addiction_risk_level, 
    concat(ROUND(AVG(monthly_game_spending_usd)::numeric, 2),'$') AS avg_monthly_spend
FROM mhgames 
GROUP BY gaming_addiction_risk_level
ORDER BY avg_monthly_spend DESC;


/* ============================================================
   Q9
   ============================================================
   Identify top 10% spenders and analyze their gaming hours.

   Purpose:
   Profile the top-decile revenue cohort: engagement intensity, platform,
   and behavioral signals. Stakeholders: Growth, Monetization, Fraud teams.
   Why it matters: Top spenders (top 10%) drive a large share of revenue;
   understanding their behavior guides retention and anti-fraud measures.
   How to use: Build tailored retention offers, monitor for unhealthy patterns,
   and cross-check with risk level to ensure ethical targeting.
*/
    SELECT 
        
        PERCENT_RANK() OVER (ORDER BY monthly_game_spending_usd DESC) as spender_rank
    FROM mhgames;
/* ============================================================
   Q10
   ============================================================
   Do high spenders exhibit higher addiction risk?

   Purpose:
   Measure overlap between high revenue users and high addiction risk.
   Stakeholders: Compliance, Legal, Finance, Ethics board.
   Why it matters: If high spend equals high risk, product teams must consider
   safeguards and transparent billing practices. How to use: Consider policy
   adjustments (spending limits, confirmations), and refer high-risk spenders
   to support resources.
*/

/* ============================================================
   Q11
   ============================================================
   Which gaming platform generates the highest total revenue?

   Purpose:
   Rank platforms by total monthly spending to identify primary revenue
   channels. Stakeholders: Platform partnerships, Business development.
   Why it matters: Guides investment, partnerships, and platform-specific
   monetization features. How to use: Prioritize platform optimizations,
   marketing budgets, and strategic deals with top revenue platforms.
*/

/* ============================================================
   Q12
   ============================================================
   Average spending per primary game.

   Purpose:
   Determine which games drive the most spending on average per user.
   Stakeholders: Game publishers, Product managers, Marketing.
   Why it matters: Reveals high-LTV titles and guides resource allocation.
   How to use: Inform promo budgets, in-game economy balance, and cross-sell.
*/

/* ============================================================
   Q13
   ============================================================
   Relationship between gaming hours and spending.

   Purpose:
   Assess whether more play time correlates with higher spending and the
   strength of that relationship. Stakeholders: Monetization, Data Science.
   Why it matters: Important for LTV prediction and understanding engagement
   => revenue conversion funnel. How to use: Create segments and run regression
   or correlation tests; if strong, design time-based monetization features.
*/

/* ============================================================
   Q14
   ============================================================
   Segment gamers into:
     - Casual (<2 hrs)
     - Moderate (2–5 hrs)
     - Hardcore (>5 hrs)

   Purpose:
   Standardize cohorts for downstream analysis and reporting.
   Stakeholders: All analytics consumers. Why it matters: Cohorts enable
   consistent comparisons and targeted strategies. How to use: Use these
   segments as dimensions in dashboards and models.
*/

/* ============================================================
   Q15
   ============================================================
   How many players fall into each gaming segment?

   Purpose:
   Measure distribution across behavioral cohorts to detect shifts
   in engagement over time. Stakeholders: Execs, Product, Marketing.
   Why it matters: If Hardcore share grows, anticipate scaling moderation
   and support. How to use: Use for prioritizing interventions and capacity.
*/

/* ============================================================
   Q16
   ============================================================
   Addiction risk distribution within each segment.

   Purpose:
   Check how intensity maps to addiction risk (e.g., % severe within Hardcore).
   Stakeholders: Health, Product Safety, Research. Why it matters:
   Confirms whether time thresholds are predictive of risk and helps
   target segment-specific interventions. How to use: Create segment-specific
   nudges, thresholds and monitoring rules.
*/

/* ============================================================
   Q17
   ============================================================
   Which game genre has the highest number of hardcore players?

   Purpose:
   Identify genres that attract heavy-engagement users. Stakeholders:
   Product, Content, Licensing. Why it matters: Genres with more hardcore
   players may require different moderation, content ratings or responsible-design
   features. How to use: Adjust genre-level policies and prioritize research.
*/

/* ============================================================
   Q18
   ============================================================
   Platform preference by gaming segment.

   Purpose:
   Understand device usage patterns within Casual/Moderate/Hardcore cohorts.
   Stakeholders: Product, Platform Partnerships. Why it matters:
   Device preference impacts UX decisions, retention tactics and platform
   optimization. How to use: Tailor features and marketing by platform+segment.
*/

/* ============================================================
   Q19
   ============================================================
   Average spending per gaming segment.

   Purpose:
   Compare monetization potential across segments to evaluate ROI of
   acquisition vs retention strategies. Stakeholders: Finance, Growth.
   Why it matters: If Casuals contribute disproportionate revenue vs costs,
   acquisition strategy should adapt. How to use: Inform LTV cohorts and unit
   economics.
*/

/* ============================================================
   Q20
   ============================================================
   Do players with eye strain game more hours?

   Purpose:
   Test association between reported eye strain and engagement intensity.
   Stakeholders: Health teams, UX designers. Why it matters: Confirms whether
   visual symptoms scale with playtime and can trigger UI/UX changes such as
   reminder timers, dark mode, or blue light filters. How to use: Implement
   in-app health nudges for groups with elevated risk.
*/

/* ============================================================
   Q21
   ============================================================
   Average sleep hours by addiction risk level.

   Purpose:
   Quantify how sleep duration varies with risk category to evaluate health
   degradation. Stakeholders: Health researchers, Policy. Why it matters:
   Direct evidence linking risk to sleep loss helps prioritize interventions.
   How to use: Create risk-based recommendations and monitor changes after
   interventions.
*/

/* ============================================================
   Q22
   ============================================================
   Exercise hours across gaming segments.

   Purpose:
   Measure differences in physical activity between Casual/Moderate/Hardcore.
   Stakeholders: Health & Wellness programs. Why it matters: Low exercise in
   heavy gamers signals lifestyle risk. How to use: Propose activity challenges,
   partnerships with wellness apps, or prompts.
*/

/* ============================================================
   Q23
   ============================================================
   Weight change trends among hardcore gamers.

   Purpose:
   Assess physical health impact (weight gain/loss) correlated with heavy gaming.
   Stakeholders: Medical researchers, Health partners. Why it matters:
   Provides evidence for physical health consequences and supports outreach.
   How to use: Design campaigns focusing on nutrition and activity for at-risk groups.
*/

/* ============================================================
   Q24
   ============================================================
   % of high-risk gamers with back/neck pain.

   Purpose:
   Quantify musculoskeletal issues among high-risk users. Stakeholders:
   Health, Ergonomics teams. Why it matters: High incidence informs ergonomic
   guidance, accessory recommendations, or in-app posture reminders. How to use:
   Implement ergonomics education and monitor incidence over time.
*/

/* ============================================================
   Q25
   ============================================================
   Sleep disruption frequency vs gaming hours.

   Purpose:
   Link frequency of sleep disruptions to gaming intensity to assess causal
   patterns. Stakeholders: Sleep researchers, Product Safety. Why it matters:
   Frequent disruptions are more actionable than average sleep hours. How to use:
   Design content scheduling limits or reminders for users with high disruption.
*/

/* ============================================================
   Q26
   ============================================================
   Average GPA across gaming segments.

   Purpose:
   Measure academic outcomes by engagement cohort (students only).
   Stakeholders: Universities, Student services, Researchers. Why it matters:
   Reveals educational risk and supports policy decisions on campus gaming.
   How to use: Recommend targeted study-support programs for heavy gamers.
*/

/* ============================================================
   Q27
   ============================================================
   Relationship between addiction risk level and GPA.

   Purpose:
   Evaluate whether higher addiction risk coincides with lower academic performance.
   Stakeholders: Education researchers, University admin. Why it matters:
   Supports evidence-based student wellbeing policies. How to use:
   Intervene with counseling or study support for high-risk students.
*/

/* ============================================================
   Q28
   ============================================================
   GPA distribution of students gaming >6 hours daily.

   Purpose:
   Study academic outcomes in an extreme-use subgroup to assess risk severity.
   Stakeholders: Student welfare, Policy makers. Why it matters:
   Extreme-use students may be disproportionately affected academically.
   How to use: Build targeted outreach and monitor GPA changes after intervention.
*/

/* ============================================================
   Q29
   ============================================================
   Relationship between sleep hours and GPA.

   Purpose:
   Test whether reduced sleep correlates with lower academic performance.
   Stakeholders: Education, Health. Why it matters:
   Sleep mediation could be an actionable lever to improve GPA. How to use:
   Incorporate sleep hygiene into student support programs.
*/

/* ============================================================
   Q30
   ============================================================
   Academic performance rating vs gaming hours.

   Purpose:
   Compare subjective academic performance ratings (Below Avg / Average / Good)
   across gaming intensity to validate self-reported performance and gaming effects.
   Stakeholders: Education, Product research. Why it matters:
   Corroborates GPA findings with self-assessments. How to use: Adjust support
   interventions based on both objective and subjective indicators.
*/

/* ============================================================
   Q31
   ============================================================
   Productivity score vs gaming hours.

   Purpose:
   Measure the relationship between time spent gaming and self-reported work
   productivity. Stakeholders: Employers, HR, Wellness teams. Why it matters:
   Helps employers gauge potential productivity loss and design flexible policies.
   How to use: Inform workplace wellness programs and recommend time-management support.
*/

/* ============================================================
   Q32
   ============================================================
   Productivity comparison across addiction risk levels.

   Purpose:
   Evaluate whether higher addiction risk leads to lower workplace productivity.
   Stakeholders: Corporate leadership, Workforce health. Why it matters:
   Quantifies business impact and potential cost of addiction. How to use:
   Consider workplace interventions, performance monitoring, and support services.
*/

/* ============================================================
   Q33
   ============================================================
   Work productivity by sleep quality.

   Purpose:
   Understand the mediating role of sleep quality on productivity outcomes.
   Stakeholders: HR, Health teams. Why it matters:
   If sleep quality strongly impacts productivity, addressing sleep can be prioritized.
   How to use: Design sleep-focused wellness initiatives and measure productivity impact.
*/

/* ============================================================
   Q34
   ============================================================
   Identify gamers with high gaming hours but high productivity.

   Purpose:
   Find resilient users or productivity outliers who maintain performance despite
   heavy gaming. Stakeholders: People Ops, Research. Why it matters:
   Helps differentiate harmful vs non-harmful heavy use and refine interventions.
   How to use: Study coping strategies of resilient users for broader programs.
*/

/* ============================================================
   Q35
   ============================================================
   Withdrawal symptoms vs addiction risk.

   Purpose:
   Assess the prevalence of withdrawal symptoms across risk levels to validate
   diagnostic markers. Stakeholders: Clinicians, Researchers. Why it matters:
   Supports clinical definitions and identifies users needing urgent care.
   How to use: Route users with withdrawal symptoms to support and monitor outcomes.
*/

/* ============================================================
   Q36
   ============================================================
   Mood swing frequency vs gaming hours.

   Purpose:
   Investigate emotional volatility as a function of engagement intensity.
   Stakeholders: Mental health teams, Researchers. Why it matters:
   High mood swing frequency linked to heavy gaming suggests psychiatric risk.
   How to use: Prioritize mental health screenings for high-risk cohorts.
*/

/* ============================================================
   Q37
   ============================================================
   Percentage of gamers continuing gaming despite problems.

   Purpose:
   Measure compulsive behavior by quantifying those who game despite negative consequences.
   Stakeholders: Clinicians, Product Ethics. Why it matters:
   Core diagnostic behavior for addiction; high percentages call for policy action.
   How to use: Implement automatic alerts, support links, or cooldown mechanics.
*/

/* ============================================================
   Q38
   ============================================================
   Mood state distribution by addiction risk.

   Purpose:
   Profile emotional states (Anxious, Irritable, Withdrawn, Angry) across risk tiers.
   Stakeholders: Mental health, Research. Why it matters:
   Helps craft mental health messaging and identify severity markers.
   How to use: Tailor support content and referral pathways by mood profiles.
*/

/* ============================================================
   Q39
   ============================================================
   Face-to-face social hours by addiction risk.

   Purpose:
   Quantify offline social interaction loss with rising addiction severity.
   Stakeholders: Social scientists, Community managers. Why it matters:
   Reduced face-to-face time indicates social withdrawal and reduced wellbeing.
   How to use: Create re-engagement activities and community-building interventions.
*/

/* ============================================================
   Q40
   ============================================================
   Social isolation score vs gaming hours.

   Purpose:
   Test correlation between isolation metric and play time to identify at-risk users.
   Stakeholders: Health research, Community teams. Why it matters:
   Supports targeted social reintegration programs. How to use:
   Prioritize outreach to users with high isolation and heavy playtime.
*/

/* ============================================================
   Q41
   ============================================================
   Identify gamers with high gaming hours and low social interaction.

   Purpose:
   Flag individual-level cases that combine heavy use and social isolation.
   Stakeholders: Support teams, Health partners. Why it matters:
   These users are prime candidates for outreach and support services.
   How to use: Build an “at-risk” list for follow-up interventions and evaluation.
*/

/* ============================================================
   Q42
   ============================================================
   Which platform has the highest addiction risk rate?

   Purpose:
   Determine platform-level concentration of addiction risk (e.g., Mobile vs PC).
   Stakeholders: Platform owners, Product policy, Partnerships. Why it matters:
   Guides platform-specific design changes and partner discussions.
   How to use: Implement platform-targeted safety features or adjust monetization.
*/

/* ============================================================
   Q43
   ============================================================
   Average gaming hours per platform.

   Purpose:
   Compare engagement intensity across platforms to support UX and hardware
   optimization. Stakeholders: Product, Dev teams. Why it matters:
   Helps prioritize platform-specific optimizations and marketing.
   How to use: Use to prioritize performance engineering and feature rollouts.
*/

/* ============================================================
   Q44
   ============================================================
   Spending behavior across platforms.

   Purpose:
   Understand where spend occurs (mobile vs PC vs console) to focus monetization.
   Stakeholders: Finance, Partnerships. Why it matters:
   Platform-specific spend patterns inform pricing and promotional strategies.
   How to use: Optimize platform billing flows and offers where spending is highest.
*/

/* ============================================================
   Q45
   ============================================================
   PC vs Console addiction comparison.

   Purpose:
   Directly compare risk and behavior between two major ecosystem types to guide
   platform policy decisions. Stakeholders: Platform teams, Regulators. Why it matters:
   Differences may call for platform-specific mitigation measures. How to use:
   Implement separate policies for PC and console as needed.
*/

/* ============================================================
   Q46
   ============================================================
   Behavioral averages of high-risk gamers.

   Purpose:
   Aggregate key metrics (gaming hours, sleep hours, spending, isolation score)
   for the High/Severe group to form a data-driven risk fingerprint.
   Stakeholders: Data Science, Health teams. Why it matters:
   Enables targeted detection rules and informs model features for prediction.
   How to use: Feed into risk models and create dashboards showing high-risk profiles.
*/

/* ============================================================
   Q47
   ============================================================
   Lifestyle profile of severe addiction gamers.

   Purpose:
   Build a multi-dimensional persona (demographics, platform, genre, health,
   social metrics) for Severe users to inform interventions and research.
   Stakeholders: Product Safety, Clinical partners. Why it matters:
   Concrete personas help operationalize support programs and communications.
   How to use: Use persona for targeted content, policy decisions and partner outreach.
*/

/* ============================================================
   Q48
   ============================================================
   Create SQL View: “At-Risk Gamers”.

   Purpose:
   Build a reusable view that flags at-risk users based on a combination of
   criteria (e.g., gaming hours > threshold, severe risk label, withdrawal symptoms,
   sleep < X). Stakeholders: Dashboard consumers, Automation engineers.
   Why it matters:
   Simplifies monitoring, automations and scheduled interventions; provides a single
   canonical source for outreach. How to use: Use the view for alerts, scheduled
   reports, and integration with support workflows.
*/

/* ============================================================
   END OF SCRIPT
   ============================================================ */
