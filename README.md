# Care247 Customer Search

A production-minded Flutter mobile application that demonstrates **configuration-driven UI**, clean architecture, robust state management, and polished Material 3 UX.

---

## Features

- **Configuration-driven search form** – fields are generated from a typed config; adding a new field requires only a config entry (no form widget changes).
- **Customer results list** with pull-to-refresh, loading / empty / error states.
- **Customer detail screen** showing basic info, addresses, phones and emails (primary items highlighted).
- **Strongly typed models** with `fromJson` / helpers.
- **Clean separation** of presentation, state and data layers.
- **Lifecycle-safe** async handling and proper disposal of controllers / focus nodes.
- **Colorful Material 3** theme with gradients, chips, and clear visual hierarchy.
- **Meaningful automated tests**.

---

## Setup and Run

### Prerequisites

- Flutter **3.16+** / Dart **3.2+** (tested against Flutter 3.24 / Dart 3.5)
- Node.js (for JSON Server)

### 1. Install dependencies

```bash
cd care247_customer_search
flutter pub get
```

### 2. Start the mock API

```bash
# Install once if needed
npm install -g json-server

# From the project root (where db.json lives)
json-server --watch db.json --port 3001
```

API endpoint: `http://localhost:3001/customers`

### 3. Configure API base URL

The base URL lives in `lib/config/app_config.dart` and can also be overridden at build time:

| Platform            | URL                                      |
|---------------------|------------------------------------------|
| Android Emulator    | `http://10.0.2.2:3001` (default)         |
| iOS Simulator       | `http://localhost:3001`                  |
| Physical device     | `http://<your-machine-ip>:3001`          |

**Override examples:**

```bash
# iOS Simulator
flutter run --dart-define=API_BASE_URL=http://localhost:3001

# Physical device (replace with your IP)
flutter run --dart-define=API_BASE_URL=http://192.168.1.42:3001
```

### 4. Run the app

```bash
flutter run
```

---

## Architecture

```
lib/
├── config/          # AppConfig + SearchConfig (configuration-driven form)
├── models/          # Strongly typed Customer, Address, Phone, Email
├── data/            # CustomerApi (HTTP) + CustomerRepository
├── state/           # CustomerSearchState (ChangeNotifier + Provider)
├── screens/         # Search, Results, Detail
├── widgets/         # DynamicSearchForm, DynamicField, ListItem, StateWidgets
├── theme/           # Colorful Material 3 theme
└── main.dart
```

### Layers

| Layer        | Responsibility                                      |
|--------------|-----------------------------------------------------|
| Presentation | Screens & widgets – no business / HTTP logic        |
| State        | `CustomerSearchState` – status, results, criteria   |
| Data         | `CustomerRepository` → `CustomerApi` (HTTP)         |

### State management

**Provider + ChangeNotifier** was chosen because:

- The app has a single primary flow (search → results → detail).
- It keeps the dependency surface minimal (only `provider`).
- Loading / success / empty / error are explicit enum values, making UI branches clear and testable.
- Only listening widgets rebuild.

### Navigation

Simple imperative `Navigator.push` with `MaterialPageRoute`. Sufficient for three linear screens; no routing package needed.

---

## Configuration-Driven Design

Search fields are defined in `lib/config/search_config.dart`:

```dart
final List<FieldConfig> searchConfig = [
  FieldConfig(key: 'firstName', type: FieldType.text, …),
  FieldConfig(key: 'lastName',  type: FieldType.text, …),
  FieldConfig(key: 'dateOfBirth', type: FieldType.date, …),
];
```

**Flow:**

```
Configuration → ordered FieldConfig list
       ↓
Generic DynamicField renderer (text / date)
       ↓
Controllers collect values into Map<String, String>
       ↓
Repository builds query params & calls API
       ↓
Results / empty / error states
```

### Adding a new search field

1. Append a `FieldConfig` to `searchConfig` (optionally set `renderOrder`).
2. Nothing else – the form, criteria collection and API query builder stay unchanged.

Example (Marital Status):

```dart
FieldConfig(
  key: 'maritalStatus',
  type: FieldType.text,
  label: 'Marital Status',
  placeholder: 'e.g. Single, Married',
  renderOrder: 4,
),
```

---

## Flutter-Specific Decisions

| Concern              | Approach                                                                 |
|----------------------|--------------------------------------------------------------------------|
| State management     | Provider + ChangeNotifier; explicit `SearchStatus` enum                  |
| Widget lifecycle     | Controllers & FocusNodes owned/disposed by `DynamicSearchForm`; `_disposed` guard in state |
| Async safety         | `if (!context.mounted) return` after awaits; state ignores updates after dispose |
| Rebuilds             | `Consumer` scopes rebuilds; `ListView.builder` for results               |
| Keyboard / forms     | `TextInputAction.next/search`, date picker (no free-text DOB), unfocus on submit |
| Performance          | Efficient list building, const constructors, no heavy work in `build()`  |

---

## Error Handling

- Network / socket failures → user-friendly message + Retry button
- Non-2xx status → status-aware message
- Malformed JSON → caught, never crashes the UI
- Empty results → dedicated empty state with guidance

---

## Testing

```bash
flutter test
```

Coverage includes:

- Customer JSON parsing (`customer_model_test.dart`)
- Search configuration ordering & extensibility (`search_config_test.dart`)
- State transitions: initial → loading → success / empty / error (`customer_search_state_test.dart`)
- Reusable list item widget (`customer_list_item_test.dart`)

---

## Trade-offs & Simplifications

- **Provider** over Riverpod / Bloc – lighter, sufficient for the scope, fewer dependencies.
- **JSON Server query params** for filtering – works well with the supplied mock; no client-side filtering needed.
- **No offline cache / persistence** – out of scope.
- **Single theme (light)** – keeps focus on architecture and UX clarity.
- **Sample `db.json` included** so the repo is immediately runnable; the assignment notes the real file is supplied separately.

---

## Time Spent

Approximately **6–7 hours** (architecture, implementation, colorful UI, tests, README).

---

## Checklist (Assignment)

- [x] Flutter + Dart, Material Design
- [x] Strongly typed models
- [x] Configuration-driven search (First Name, Last Name, DOB)
- [x] New field can be added without changing form rendering code
- [x] Results list with required fields + pull-to-refresh
- [x] Detail screen with all sections
- [x] Loading / empty / error states
- [x] API failures handled gracefully
- [x] Keyboard & date-picker behaviour
- [x] Lifecycle-safe async + disposal
- [x] Efficient list rendering
- [x] State separated from UI
- [x] Automated tests
- [x] Complete README
