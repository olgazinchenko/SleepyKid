<h1>SleepyKid</h1>
<p>SleepyKid is a mobile application that helps parents track and review their children’s sleep. The app follows the <strong>MVVM</strong> (Model–View–ViewModel) architecture and is built with <strong>Core Data</strong> and <strong>SnapKit</strong>. UI is fully programmatic (no storyboards).</p>

<h3>Screens</h3>
<table border="0">
  <tbody>
    <tr>
      <td><img width="447" height="896" alt="SplashScreen" src="https://github.com/olgazinchenko/SleepyKid/assets/34693435/8c665042-b0e2-4f71-bbc4-12cedefa2a9e" /></td>
      <td><img width="447" height="896" alt="Edit Kid" src="https://github.com/user-attachments/assets/c3f6e50d-b517-4993-8810-b1815f119048" /></td>
      <td><img width="447" height="898" alt="Kids List" src="https://github.com/user-attachments/assets/726fe24f-dab7-401d-8e17-980adcd76af1" /></td>
      <td><img width="447" height="897" alt="Sleep Edit" src="https://github.com/user-attachments/assets/6b5a10c8-6ac5-48e6-8cb8-3c550a799d1c" /></td>
      <td><img width="447" height="897" alt="Sleeps List" src="https://github.com/user-attachments/assets/f6fb9057-ab4a-4e02-bb95-ccdf61741088" /></td>
    </tr>
  </tbody>
</table>

<ul>
  <li><strong>SplashScreen</strong>: Initial loading screen.</li>
  <li><strong>KidsListScreen</strong>: List of kids with avatars and <em>relative age</em> (e.g., “4 y 6 m”, “16 d”). Tap a kid to open their sleeps; long-press to edit or delete. Floating “+” adds a kid.</li>
  <li><strong>KidDetails (Add/Edit)</strong>: Single form for adding or editing a kid. Fields: <em>Kid name</em> and <em>Date of birth</em>. Age is calculated automatically from DOB. “Save” in the top-right; delete via the red FAB.</li>
  <li><strong>SleepsListScreen</strong>: Day-based list of sleep sessions for the selected kid with header date and left/right day navigation. Each card shows start–end time, duration, and sequence number; the dot on the right shows <em>awake interval since previous sleep</em>. “+” adds a new sleep.</li>
  <li><strong>SleepDetails (Add/Edit)</strong>: Start and end <em>date & time</em> pickers with computed duration preview and day/night icon. Delete via the red FAB.</li>
</ul>

<h3>Current features</h3>
<ul>
  <li>MVVM, Core Data persistence, SnapKit-based layout, programmatic UI.</li>
  <li>Kid profiles with DOB → automatic age calculation and relative age display.</li>
  <li>Per-kid, per-day sleep tracking with quick day navigation.</li>
  <li>Computed duration for each sleep and <em>awake intervals</em> between sleeps on the list.</li>
</ul>

<hr />

<h2>TODO</h2>

<h3>Screens</h3>
<ul>
  <li><strong>WelcomeScreen</strong>: Choice between login and registration.</li>
  <li><strong>SignUpScreen</strong>: Registration (email, password, first &amp; last name).</li>
  <li><strong>LoginScreen</strong>: Email/password sign-in.</li>
  <li><strong>StatisticsScreen</strong>: Trends and aggregated sleep stats.</li>
</ul>

<h3>Features</h3>
<ul>
  <li><strong>Validation &amp; notifications</strong>: Prevent invalid periods (e.g., overlaps, negative durations) and inform the user.</li>
  <li><strong>Localization</strong>: Multi-language support.</li>
  <li><strong>Import/Export</strong>: Backup/restore and sharing of data.</li>
  <li><strong>Tooltips</strong>: Contextual help for controls and screens.</li>
</ul>

<hr />

<p>This project is under active development. Feedback and contributions are welcome — please open issues or PRs in the <a href="https://github.com/olgazinchenko/SleepyKid">GitHub repository</a>.</p>
