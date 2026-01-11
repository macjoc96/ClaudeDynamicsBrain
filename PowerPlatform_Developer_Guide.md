# Power Platform Developer Guide
## Kompletny poradnik dla deweloperów Microsoft Dynamics 365 i Power Platform

**Wersja:** 1.0.0
**Data:** Styczeń 2026
**Autor:** Claude (ClaudeDynamicsBrain)
**Źródło:** https://github.com/macjoc96/ClaudeDynamicsBrain

---

## O tym poradniku

Ten kompleksowy przewodnik został stworzony dla deweloperów na wszystkich poziomach zaawansowania - od juniorów rozpoczynających swoją przygodę z Power Platform, przez developerów mid-level rozwijających swoje umiejętności, po seniorów i architektów projektujących rozwiązania enterprise.

### Dla kogo jest ten poradnik?

- **Junior Developers** - Część I zapewnia solidne fundamenty programistyczne
- **Mid-Level Developers** - Część II pokrywa core development w Dynamics 365
- **Senior Developers** - Część III zawiera zaawansowane tematy i optymalizacje
- **Tech Leads & Architects** - Część IV skupia się na architekturze i leadership

### Struktura poradnika

**CZĘŚĆ I: FUNDAMENTY PROGRAMISTYCZNE (Junior)**
1. C# dla Power Platform
2. TypeScript/JavaScript dla Power Platform
3. SQL i zapytania w Dynamics
4. Narzędzia deweloperskie

**CZĘŚĆ II: CORE DYNAMICS 365 DEVELOPMENT (Mid)**
5. Plugin Development
6. Custom Actions & Workflows
7. Web Resources
8. Dataverse API
9. Power Automate (Cloud Flows)

**CZĘŚĆ III: ZAAWANSOWANE TEMATY (Senior)**
10. Architektura rozwiązań
11. Performance & Optimization
12. Security Architecture
13. Integracje
14. Testing & Quality

**CZĘŚĆ IV: TECH LEAD & ARCHITECT (Expert)**
15. Enterprise Architecture
16. Team Leadership
17. Governance & Standards
18. Strategic Planning

### Konwencje używane w tym dokumencie

> 💡 **TIP** - Pomocne wskazówki i best practices

> ⚠️ **WARNING** - Ostrzeżenia o potencjalnych problemach

> 📌 **NOTE** - Ważne informacje do zapamiętania

> ✅ **DO** - Zalecane praktyki

> ❌ **DON'T** - Praktyki do unikania

### Wymagania wstępne

Aby maksymalnie wykorzystać ten poradnik, powinieneś mieć:
- Podstawową znajomość programowania (dowolny język)
- Dostęp do środowiska Power Platform (trial wystarczy)
- Visual Studio lub Visual Studio Code
- Chęć nauki i eksperymentowania

---

# CZĘŚĆ I: FUNDAMENTY PROGRAMISTYCZNE

> 💡 **TIP**: Ta część jest kluczowa dla wszystkich, którzy dopiero zaczynają z Power Platform. Nawet jeśli znasz podstawy C# lub JavaScript, zalecamy przejrzenie tych rozdziałów - znajdziesz tu kontekst specyficzny dla Dynamics 365.

---

# Rozdział 1: C# dla Power Platform

## Wprowadzenie

C# jest podstawowym językiem programowania dla rozwoju server-side w ekosystemie Dynamics 365. Wszystkie pluginy, custom workflow activities oraz wiele innych rozszerzeń jest pisanych w C#. Ten rozdział wprowadzi Cię w fundament języka C# z perspektywą wykorzystania w Power Platform.

### Czego się nauczysz?

W tym rozdziale poznasz:
- Podstawowe typy danych i ich zastosowanie w Dynamics
- Koncepcje programowania obiektowego w kontekście pluginów
- LINQ do efektywnego przetwarzania danych
- Asynchroniczne programowanie dla długotrwałych operacji
- Dependency Injection dla testowania i maintainability

### Dlaczego C# w Power Platform?

C# jest językiem wyboru dla Dynamics 365 z kilku kluczowych powodów:
- **Silne typowanie** - wyłapuje błędy na etapie kompilacji
- **Wydajność** - skompilowany kod działa szybko
- **Ekosystem** - bogaty zbiór bibliotek i narzędzi
- **Wsparcie Microsoft** - pełna integracja z platformą

---

## 1.1 Podstawy języka C#

### Typy wartościowe vs referencyjne

W C# rozróżniamy dwa fundamentalne rodzaje typów danych:

**Typy wartościowe (Value Types)**
- Przechowywane na stosie (stack)
- Kopiowane przez wartość
- Przykłady: `int`, `bool`, `decimal`, `DateTime`, `struct`

**Typy referencyjne (Reference Types)**
- Przechowywane na stercie (heap)
- Kopiowane przez referencję
- Przykłady: `string`, `class`, `interface`, `array`

#### Przykład praktyczny w kontekście Dynamics

```csharp
using Microsoft.Xrm.Sdk;
using System;

namespace DynamicsExamples
{
    public class TypesExample
    {
        public void DemonstrateTypes(IOrganizationService service)
        {
            // Typy wartościowe
            int recordCount = 100;              // int - typ wartościowy
            decimal totalRevenue = 50000.50m;   // decimal - typ wartościowy
            bool isActive = true;               // bool - typ wartościowy
            DateTime createdDate = DateTime.Now; // struct - typ wartościowy

            // Typy referencyjne
            string accountName = "Contoso Ltd";  // string - typ referencyjny
            Entity account = new Entity("account"); // class - typ referencyjny

            // Demonstracja kopiowania wartościowego
            int count1 = 10;
            int count2 = count1; // Kopiowanie wartości
            count2 = 20;
            // count1 nadal wynosi 10, count2 wynosi 20

            // Demonstracja kopiowania referencyjnego
            Entity entity1 = new Entity("contact");
            entity1["firstname"] = "John";

            Entity entity2 = entity1; // Kopiowanie referencji!
            entity2["firstname"] = "Jane";

            // Oba wskazują na ten sam obiekt - entity1["firstname"] też wynosi "Jane"
            Console.WriteLine(entity1["firstname"]); // Output: Jane
        }
    }
}
```

> ⚠️ **WARNING**: Najczęstszy błąd początkujących to myślenie że `Entity entity2 = entity1` tworzy kopię encji. W rzeczywistości oba wskazują na ten sam obiekt w pamięci!

### Nullable types i null safety

W Dynamics 365 często spotykamy się z wartościami null (np. puste pola w rekordach). C# oferuje nullable types do bezpiecznej obsługi takich sytuacji.

```csharp
using Microsoft.Xrm.Sdk;
using System;

namespace DynamicsExamples
{
    public class NullableExample
    {
        public void SafelyHandleNullableValues(Entity account)
        {
            // ❌ ŹLE - może rzucić NullReferenceException
            DateTime createdOn = (DateTime)account["createdon"];

            // ✅ DOBRZE - bezpieczne sprawdzenie
            if (account.Contains("createdon") && account["createdon"] != null)
            {
                DateTime createdOn = (DateTime)account["createdon"];
                Console.WriteLine($"Created: {createdOn:yyyy-MM-dd}");
            }

            // ✅ JESZCZE LEPIEJ - użycie GetAttributeValue
            DateTime? createdOn = account.GetAttributeValue<DateTime?>("createdon");
            if (createdOn.HasValue)
            {
                Console.WriteLine($"Created: {createdOn.Value:yyyy-MM-dd}");
            }

            // ✅ NAJLEPIEJ - null coalescing operator
            DateTime effectiveDate = account.GetAttributeValue<DateTime?>("createdon")
                                   ?? DateTime.Now;

            // Nullable value types
            int? numberOfEmployees = account.GetAttributeValue<int?>("numberofemployees");
            decimal? revenue = account.GetAttributeValue<Money>("revenue")?.Value;

            // Null-conditional operator (?.)
            string primaryContactName = account.GetAttributeValue<EntityReference>("primarycontactid")?.Name;

            // Null coalescing assignment (C# 8.0+)
            string accountName = account.GetAttributeValue<string>("name");
            accountName ??= "Unknown Account"; // Przypisz jeśli null
        }

        public decimal CalculateDiscount(Entity opportunity)
        {
            // Bezpieczne obliczenia z nullable
            decimal? estimatedValue = opportunity.GetAttributeValue<Money>("estimatedvalue")?.Value;
            int? discountPercent = opportunity.GetAttributeValue<int?>("discountpercentage");

            if (estimatedValue.HasValue && discountPercent.HasValue)
            {
                return estimatedValue.Value * (discountPercent.Value / 100m);
            }

            return 0m; // Domyślna wartość jeśli brak danych
        }
    }
}
```

> 💡 **TIP**: Zawsze używaj `GetAttributeValue<T>()` zamiast bezpośredniego rzutowania. Jest to bezpieczniejsze i czytelniejsze.

### Collections (List, Dictionary, HashSet)

W Dynamics 365 często pracujemy z kolekcjami encji, atrybutów czy relacji. Poznanie kolekcji C# jest kluczowe.

```csharp
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Query;
using System;
using System.Collections.Generic;
using System.Linq;

namespace DynamicsExamples
{
    public class CollectionsExample
    {
        private IOrganizationService _service;

        public CollectionsExample(IOrganizationService service)
        {
            _service = service;
        }

        public void DemonstrateList()
        {
            // List<T> - najczęściej używana kolekcja
            List<Entity> accounts = new List<Entity>();

            // Dodawanie elementów
            Entity account1 = new Entity("account");
            account1["name"] = "Contoso";
            accounts.Add(account1);

            Entity account2 = new Entity("account");
            account2["name"] = "Fabrikam";
            accounts.Add(account2);

            // Iteracja przez listę
            foreach (Entity account in accounts)
            {
                Console.WriteLine(account.GetAttributeValue<string>("name"));
            }

            // Inicjalizacja kolekcji
            List<string> statuses = new List<string> { "Active", "Inactive", "Pending" };

            // Operacje na liście
            int count = accounts.Count;
            Entity firstAccount = accounts[0]; // Dostęp przez indeks
            bool containsContoso = accounts.Any(a =>
                a.GetAttributeValue<string>("name") == "Contoso");
        }

        public void DemonstrateDictionary()
        {
            // Dictionary<TKey, TValue> - szybkie wyszukiwanie po kluczu
            Dictionary<Guid, Entity> accountsById = new Dictionary<Guid, Entity>();

            // Dodawanie elementów
            Entity account = new Entity("account", Guid.NewGuid());
            account["name"] = "Contoso";
            accountsById.Add(account.Id, account);

            // Bezpieczne dodawanie (nie rzuca wyjątku jeśli klucz istnieje)
            accountsById[account.Id] = account;

            // Sprawdzanie czy klucz istnieje
            Guid searchId = Guid.NewGuid();
            if (accountsById.ContainsKey(searchId))
            {
                Entity foundAccount = accountsById[searchId];
            }

            // TryGetValue - bezpieczniejszy sposób
            if (accountsById.TryGetValue(searchId, out Entity result))
            {
                Console.WriteLine(result.GetAttributeValue<string>("name"));
            }

            // Iteracja przez słownik
            foreach (KeyValuePair<Guid, Entity> kvp in accountsById)
            {
                Guid id = kvp.Key;
                Entity acc = kvp.Value;
                Console.WriteLine($"{id}: {acc.GetAttributeValue<string>("name")}");
            }

            // Praktyczny przykład: cache encji
            Dictionary<string, Entity> entityCache = new Dictionary<string, Entity>();
            string cacheKey = "account_" + account.Id;
            entityCache[cacheKey] = account;
        }

        public void DemonstrateHashSet()
        {
            // HashSet<T> - unikalne wartości, szybkie sprawdzanie membership
            HashSet<Guid> processedIds = new HashSet<Guid>();

            // Dodawanie (ignoruje duplikaty)
            Guid id1 = Guid.NewGuid();
            processedIds.Add(id1);
            processedIds.Add(id1); // Nie doda duplikatu

            // Sprawdzanie czy element istnieje (O(1) - bardzo szybkie!)
            if (processedIds.Contains(id1))
            {
                Console.WriteLine("Already processed");
            }

            // Praktyczny przykład: unikanie infinite loop w pluginie
            public void PreventInfiniteLoop(Entity target, HashSet<Guid> processedEntities)
            {
                if (processedEntities.Contains(target.Id))
                {
                    return; // Już przetwarzaliśmy tę encję
                }

                processedEntities.Add(target.Id);

                // Wykonaj logikę...
                ProcessEntity(target);
            }

            // Operacje na zbiorach
            HashSet<string> set1 = new HashSet<string> { "A", "B", "C" };
            HashSet<string> set2 = new HashSet<string> { "B", "C", "D" };

            // Union (suma zbiorów)
            set1.UnionWith(set2); // set1 = { "A", "B", "C", "D" }

            // Intersection (część wspólna)
            set1.IntersectWith(set2); // set1 = { "B", "C" }
        }

        private void ProcessEntity(Entity entity)
        {
            // Implementation
        }
    }
}
```

> 💡 **TIP**:
> - Użyj `List<T>` gdy potrzebujesz uporządkowanej kolekcji
> - Użyj `Dictionary<TKey, TValue>` gdy potrzebujesz szybkiego wyszukiwania po kluczu
> - Użyj `HashSet<T>` gdy potrzebujesz unikalnych wartości lub szybkiego sprawdzania czy element istnieje

### Anti-patterns do unikania

```csharp
// ❌ ŹLE: Używanie ArrayList zamiast List<T>
ArrayList accounts = new ArrayList(); // Brak type safety!
accounts.Add(new Entity("account"));
accounts.Add("string"); // Kompilator nie wyłapie błędu!
Entity account = (Entity)accounts[0]; // Konieczne rzutowanie

// ✅ DOBRZE: Używanie generycznej List<T>
List<Entity> accountsList = new List<Entity>();
accountsList.Add(new Entity("account"));
// accountsList.Add("string"); // Błąd kompilacji!
Entity firstAccount = accountsList[0]; // Brak konieczności rzutowania

// ❌ ŹLE: Ignorowanie null bez sprawdzenia
string accountName = entity["name"].ToString(); // NullReferenceException!

// ✅ DOBRZE: Bezpieczna obsługa null
string accountName = entity.GetAttributeValue<string>("name") ?? "Unknown";

// ❌ ŹLE: Modyfikowanie kolekcji podczas iteracji
foreach (Entity account in accounts)
{
    if (account.GetAttributeValue<bool>("isdeleted"))
    {
        accounts.Remove(account); // InvalidOperationException!
    }
}

// ✅ DOBRZE: Użycie LINQ lub oddzielnej listy
List<Entity> accountsToRemove = accounts
    .Where(a => a.GetAttributeValue<bool>("isdeleted"))
    .ToList();
foreach (Entity account in accountsToRemove)
{
    accounts.Remove(account);
}

// LUB jeszcze lepiej:
accounts = accounts.Where(a => !a.GetAttributeValue<bool>("isdeleted")).ToList();
```

---

## 1.2 Programowanie obiektowe

### Klasy, interfejsy, dziedziczenie

Programowanie obiektowe (OOP) jest fundamentem architektury pluginów i rozszerzeń w Dynamics 365. Zrozumienie tych koncepcji jest kluczowe.

#### Klasy w kontekście Dynamics

```csharp
using Microsoft.Xrm.Sdk;
using System;

namespace DynamicsExamples
{
    // Podstawowa klasa reprezentująca logikę biznesową
    public class AccountManager
    {
        // Pola (fields) - prywatne dane klasy
        private readonly IOrganizationService _service;
        private readonly ITracingService _tracing;

        // Właściwości (properties) - kontrolowany dostęp do danych
        public string DefaultAccountCategory { get; set; }
        public int MaxAccountsPerBatch { get; private set; }

        // Konstruktor - inicjalizacja obiektu
        public AccountManager(IOrganizationService service, ITracingService tracing)
        {
            _service = service ?? throw new ArgumentNullException(nameof(service));
            _tracing = tracing ?? throw new ArgumentNullException(nameof(tracing));

            // Domyślne wartości
            DefaultAccountCategory = "Standard";
            MaxAccountsPerBatch = 100;
        }

        // Metody - zachowania klasy
        public Guid CreateAccount(string name, string category = null)
        {
            _tracing.Trace($"Creating account: {name}");

            Entity account = new Entity("account");
            account["name"] = name;
            account["accountcategorycode"] = new OptionSetValue(
                GetCategoryCode(category ?? DefaultAccountCategory)
            );

            Guid accountId = _service.Create(account);
            _tracing.Trace($"Account created with ID: {accountId}");

            return accountId;
        }

        public void UpdateAccountStatus(Guid accountId, bool isActive)
        {
            Entity account = new Entity("account", accountId);
            account["statecode"] = new OptionSetValue(isActive ? 0 : 1);

            _service.Update(account);
            _tracing.Trace($"Account {accountId} status updated to {(isActive ? "Active" : "Inactive")}");
        }

        // Private helper method
        private int GetCategoryCode(string category)
        {
            switch (category.ToLower())
            {
                case "preferred": return 1;
                case "standard": return 2;
                default: return 2;
            }
        }
    }
}
```

#### Interfejsy - kontrakty dla klas

```csharp
using Microsoft.Xrm.Sdk;
using System;
using System.Collections.Generic;

namespace DynamicsExamples
{
    // Interface definiuje kontrakt - co klasa musi implementować
    public interface IEntityValidator
    {
        bool Validate(Entity entity);
        List<string> GetValidationErrors(Entity entity);
    }

    // Interface dla operacji CRUD
    public interface IEntityRepository
    {
        Guid Create(Entity entity);
        Entity Retrieve(string entityName, Guid id);
        void Update(Entity entity);
        void Delete(string entityName, Guid id);
    }

    // Implementacja interfejsu walidatora dla Account
    public class AccountValidator : IEntityValidator
    {
        public bool Validate(Entity entity)
        {
            if (entity.LogicalName != "account")
                return false;

            // Nazwa jest wymagana
            if (!entity.Contains("name") || string.IsNullOrWhiteSpace(entity.GetAttributeValue<string>("name")))
                return false;

            // Nazwa nie może być dłuższa niż 160 znaków
            string name = entity.GetAttributeValue<string>("name");
            if (name.Length > 160)
                return false;

            return true;
        }

        public List<string> GetValidationErrors(Entity entity)
        {
            List<string> errors = new List<string>();

            if (entity.LogicalName != "account")
            {
                errors.Add("Entity must be of type 'account'");
            }

            if (!entity.Contains("name") || string.IsNullOrWhiteSpace(entity.GetAttributeValue<string>("name")))
            {
                errors.Add("Account name is required");
            }
            else
            {
                string name = entity.GetAttributeValue<string>("name");
                if (name.Length > 160)
                {
                    errors.Add($"Account name exceeds maximum length of 160 characters (current: {name.Length})");
                }
            }

            return errors;
        }
    }

    // Implementacja repository pattern
    public class EntityRepository : IEntityRepository
    {
        private readonly IOrganizationService _service;

        public EntityRepository(IOrganizationService service)
        {
            _service = service;
        }

        public Guid Create(Entity entity)
        {
            return _service.Create(entity);
        }

        public Entity Retrieve(string entityName, Guid id)
        {
            return _service.Retrieve(entityName, id, new Microsoft.Xrm.Sdk.Query.ColumnSet(true));
        }

        public void Update(Entity entity)
        {
            _service.Update(entity);
        }

        public void Delete(string entityName, Guid id)
        {
            _service.Delete(entityName, id);
        }
    }
}
```

> 💡 **TIP**: Interfejsy są kluczowe dla testowania. Pozwalają na tworzenie mock'ów i stub'ów w unit testach.

#### Dziedziczenie

```csharp
using Microsoft.Xrm.Sdk;
using System;

namespace DynamicsExamples
{
    // Bazowa klasa dla wszystkich walidatorów
    public abstract class BaseEntityValidator
    {
        protected ITracingService Tracing { get; }

        protected BaseEntityValidator(ITracingService tracing)
        {
            Tracing = tracing;
        }

        // Template Method Pattern
        public bool ValidateEntity(Entity entity)
        {
            Tracing.Trace($"Starting validation for {entity.LogicalName}");

            // Wspólna walidacja dla wszystkich encji
            if (entity == null)
            {
                Tracing.Trace("Entity is null");
                return false;
            }

            if (entity.Id == Guid.Empty && !entity.Contains("id"))
            {
                Tracing.Trace("Warning: Entity has no ID");
            }

            // Wywołanie specyficznej walidacji (implementowanej przez klasy pochodne)
            bool isValid = ValidateSpecific(entity);

            Tracing.Trace($"Validation result: {isValid}");
            return isValid;
        }

        // Abstract method - musi być implementowana przez klasy pochodne
        protected abstract bool ValidateSpecific(Entity entity);

        // Virtual method - może być nadpisana, ale nie musi
        protected virtual void LogValidationError(string message)
        {
            Tracing.Trace($"Validation Error: {message}");
        }
    }

    // Klasa pochodna dla Account
    public class AccountValidator : BaseEntityValidator
    {
        public AccountValidator(ITracingService tracing) : base(tracing)
        {
        }

        protected override bool ValidateSpecific(Entity entity)
        {
            if (entity.LogicalName != "account")
            {
                LogValidationError("Entity is not an account");
                return false;
            }

            string name = entity.GetAttributeValue<string>("name");
            if (string.IsNullOrWhiteSpace(name))
            {
                LogValidationError("Account name is required");
                return false;
            }

            return true;
        }

        // Override virtual method
        protected override void LogValidationError(string message)
        {
            base.LogValidationError(message); // Wywołaj bazową implementację
            // Dodatkowa logika specyficzna dla Account
            Tracing.Trace("Consider checking account creation template");
        }
    }

    // Klasa pochodna dla Contact
    public class ContactValidator : BaseEntityValidator
    {
        public ContactValidator(ITracingService tracing) : base(tracing)
        {
        }

        protected override bool ValidateSpecific(Entity entity)
        {
            if (entity.LogicalName != "contact")
            {
                LogValidationError("Entity is not a contact");
                return false;
            }

            // Contact musi mieć albo firstname albo lastname
            string firstName = entity.GetAttributeValue<string>("firstname");
            string lastName = entity.GetAttributeValue<string>("lastname");

            if (string.IsNullOrWhiteSpace(firstName) && string.IsNullOrWhiteSpace(lastName))
            {
                LogValidationError("Contact must have either first name or last name");
                return false;
            }

            return true;
        }
    }
}
```

### Polimorfizm i enkapsulacja

```csharp
using Microsoft.Xrm.Sdk;
using System;
using System.Collections.Generic;

namespace DynamicsExamples
{
    // Polimorfizm - różne implementacje tego samego interfejsu
    public interface INotificationSender
    {
        void Send(string recipient, string message);
    }

    public class EmailNotificationSender : INotificationSender
    {
        private readonly IOrganizationService _service;

        public EmailNotificationSender(IOrganizationService service)
        {
            _service = service;
        }

        public void Send(string recipient, string message)
        {
            Entity email = new Entity("email");
            email["to"] = new Entity[] { new Entity("contact") { ["emailaddress1"] = recipient } };
            email["subject"] = "Notification";
            email["description"] = message;

            _service.Create(email);
        }
    }

    public class SMSNotificationSender : INotificationSender
    {
        private readonly IOrganizationService _service;

        public SMSNotificationSender(IOrganizationService service)
        {
            _service = service;
        }

        public void Send(string recipient, string message)
        {
            // Logika wysyłania SMS (np. przez custom entity lub external API)
            Entity sms = new Entity("cr9e5_sms");
            sms["cr9e5_phonenumber"] = recipient;
            sms["cr9e5_message"] = message;

            _service.Create(sms);
        }
    }

    // Użycie polimorfizmu
    public class NotificationManager
    {
        private readonly List<INotificationSender> _senders;

        public NotificationManager()
        {
            _senders = new List<INotificationSender>();
        }

        public void AddSender(INotificationSender sender)
        {
            _senders.Add(sender);
        }

        public void NotifyAll(string recipient, string message)
        {
            // Polimorfizm w akcji - każdy sender ma swoją implementację
            foreach (INotificationSender sender in _senders)
            {
                sender.Send(recipient, message);
            }
        }
    }

    // Enkapsulacja - ukrywanie szczegółów implementacji
    public class SecureConnectionStringManager
    {
        // Prywatne pole - niedostępne z zewnątrz
        private string _connectionString;

        // Właściwość tylko do odczytu
        public bool IsConnected { get; private set; }

        // Publiczny konstruktor
        public SecureConnectionStringManager()
        {
            _connectionString = string.Empty;
            IsConnected = false;
        }

        // Publiczna metoda do ustawiania connection string z walidacją
        public void SetConnectionString(string connectionString)
        {
            if (string.IsNullOrWhiteSpace(connectionString))
            {
                throw new ArgumentException("Connection string cannot be empty", nameof(connectionString));
            }

            if (!connectionString.Contains("Url="))
            {
                throw new ArgumentException("Invalid connection string format", nameof(connectionString));
            }

            _connectionString = connectionString;
            IsConnected = true;
        }

        // Metoda zwraca zamaskowany connection string (bezpieczeństwo)
        public string GetMaskedConnectionString()
        {
            if (string.IsNullOrEmpty(_connectionString))
                return "Not configured";

            // Zwróć tylko URL, ukryj credentials
            int urlIndex = _connectionString.IndexOf("Url=");
            if (urlIndex >= 0)
            {
                int endIndex = _connectionString.IndexOf(";", urlIndex);
                if (endIndex > urlIndex)
                {
                    return _connectionString.Substring(urlIndex, endIndex - urlIndex);
                }
            }

            return "Configured (credentials hidden)";
        }

        // Prywatna metoda pomocnicza - niedostępna z zewnątrz
        private void ValidateConnection()
        {
            // Logika walidacji połączenia
        }
    }
}
```

### Abstract classes vs interfaces

```csharp
using Microsoft.Xrm.Sdk;
using System;

namespace DynamicsExamples
{
    // INTERFACE - kontrakt bez implementacji
    public interface IPluginLogger
    {
        void LogInfo(string message);
        void LogError(string message, Exception ex);
    }

    // ABSTRACT CLASS - częściowa implementacja
    public abstract class BasePlugin : IPlugin
    {
        // Może mieć pola i właściwości
        protected string PluginName { get; }

        // Konstruktor
        protected BasePlugin(string pluginName)
        {
            PluginName = pluginName;
        }

        // Implementacja IPlugin.Execute z wspólną logiką
        public void Execute(IServiceProvider serviceProvider)
        {
            // Pobierz kontekst (wspólne dla wszystkich pluginów)
            IPluginExecutionContext context = (IPluginExecutionContext)serviceProvider.GetService(typeof(IPluginExecutionContext));
            IOrganizationServiceFactory factory = (IOrganizationServiceFactory)serviceProvider.GetService(typeof(IOrganizationServiceFactory));
            IOrganizationService service = factory.CreateOrganizationService(context.UserId);
            ITracingService tracing = (ITracingService)serviceProvider.GetService(typeof(ITracingService));

            try
            {
                tracing.Trace($"{PluginName} started");

                // Wywołaj specyficzną logikę (abstract method)
                ExecutePlugin(context, service, tracing);

                tracing.Trace($"{PluginName} completed successfully");
            }
            catch (Exception ex)
            {
                tracing.Trace($"{PluginName} error: {ex.Message}");
                throw new InvalidPluginExecutionException($"Error in {PluginName}: {ex.Message}", ex);
            }
        }

        // Abstract method - każdy plugin musi to zaimplementować
        protected abstract void ExecutePlugin(
            IPluginExecutionContext context,
            IOrganizationService service,
            ITracingService tracing);

        // Virtual method - może być nadpisana, ale nie musi
        protected virtual bool ShouldExecute(IPluginExecutionContext context)
        {
            // Domyślnie wykonaj plugin
            return true;
        }

        // Helper method dostępna dla wszystkich klas pochodnych
        protected Entity GetTargetEntity(IPluginExecutionContext context)
        {
            if (context.InputParameters.Contains("Target") && context.InputParameters["Target"] is Entity)
            {
                return (Entity)context.InputParameters["Target"];
            }
            return null;
        }
    }

    // Konkretna implementacja pluginu
    public class AccountCreatePlugin : BasePlugin
    {
        public AccountCreatePlugin() : base("AccountCreatePlugin")
        {
        }

        protected override void ExecutePlugin(
            IPluginExecutionContext context,
            IOrganizationService service,
            ITracingService tracing)
        {
            // Sprawdź czy plugin powinien być wykonany
            if (!ShouldExecute(context))
            {
                tracing.Trace("Plugin execution skipped");
                return;
            }

            Entity target = GetTargetEntity(context);
            if (target == null || target.LogicalName != "account")
            {
                return;
            }

            // Specyficzna logika dla tworzenia Account
            if (!target.Contains("accountcategorycode"))
            {
                target["accountcategorycode"] = new OptionSetValue(1); // Default category
                tracing.Trace("Set default account category");
            }
        }

        protected override bool ShouldExecute(IPluginExecutionContext context)
        {
            // Wykonaj tylko na Create message
            return context.MessageName.Equals("Create", StringComparison.OrdinalIgnoreCase);
        }
    }
}
```

**Kiedy używać Interface vs Abstract Class?**

| Aspekt | Interface | Abstract Class |
|--------|-----------|----------------|
| Wielodziedziczenie | ✅ Klasa może implementować wiele interfejsów | ❌ Klasa może dziedziczyć tylko z jednej klasy |
| Implementacja | ❌ Tylko deklaracje metod (C# 8.0+ pozwala na default implementation) | ✅ Może zawierać implementację |
| Pola | ❌ Nie może mieć pól | ✅ Może mieć pola |
| Konstruktory | ❌ Nie może mieć konstruktorów | ✅ Może mieć konstruktory |
| Access modifiers | ❌ Wszystko public | ✅ Różne modyfikatory dostępu |
| Kiedy używać | Definiowanie kontraktu, który różne klasy mogą implementować | Dzielenie wspólnej funkcjonalności między powiązane klasy |

> 💡 **TIP**: W Dynamics 365 pluginach używaj abstract class jako bazy dla wszystkich pluginów (wspólna logika), a interface dla serwisów (dependency injection, testowanie).

### Praktyczny przykład: Plugin z OOP

```csharp
using Microsoft.Xrm.Sdk;
using System;

namespace DynamicsExamples.Plugins
{
    // Interface dla walidacji
    public interface IEntityValidator
    {
        bool Validate(Entity entity);
        string GetValidationMessage();
    }

    // Interface dla business logic
    public interface IAccountBusinessLogic
    {
        void SetDefaultValues(Entity account);
        void CalculateAccountRating(Entity account, IOrganizationService service);
    }

    // Implementacja walidatora
    public class AccountValidator : IEntityValidator
    {
        private string _validationMessage;

        public bool Validate(Entity entity)
        {
            if (entity.LogicalName != "account")
            {
                _validationMessage = "Entity must be an account";
                return false;
            }

            string name = entity.GetAttributeValue<string>("name");
            if (string.IsNullOrWhiteSpace(name))
            {
                _validationMessage = "Account name is required";
                return false;
            }

            if (name.Length > 160)
            {
                _validationMessage = "Account name exceeds maximum length of 160 characters";
                return false;
            }

            return true;
        }

        public string GetValidationMessage()
        {
            return _validationMessage ?? "Validation passed";
        }
    }

    // Implementacja business logic
    public class AccountBusinessLogic : IAccountBusinessLogic
    {
        private readonly ITracingService _tracing;

        public AccountBusinessLogic(ITracingService tracing)
        {
            _tracing = tracing;
        }

        public void SetDefaultValues(Entity account)
        {
            // Ustaw domyślną kategorię jeśli nie podano
            if (!account.Contains("accountcategorycode"))
            {
                account["accountcategorycode"] = new OptionSetValue(1);
                _tracing.Trace("Set default account category to Preferred Customer");
            }

            // Ustaw domyślny status jeśli nie podano
            if (!account.Contains("statecode"))
            {
                account["statecode"] = new OptionSetValue(0); // Active
                _tracing.Trace("Set default state to Active");
            }
        }

        public void CalculateAccountRating(Entity account, IOrganizationService service)
        {
            // Pobierz powiązane opportunities
            decimal? totalRevenue = account.GetAttributeValue<Money>("revenue")?.Value;

            int rating;
            if (totalRevenue.HasValue)
            {
                if (totalRevenue.Value >= 1000000)
                    rating = 1; // Hot
                else if (totalRevenue.Value >= 500000)
                    rating = 2; // Warm
                else
                    rating = 3; // Cold
            }
            else
            {
                rating = 3; // Cold by default
            }

            account["accountratingcode"] = new OptionSetValue(rating);
            _tracing.Trace($"Calculated account rating: {rating}");
        }
    }

    // Abstract base plugin
    public abstract class BasePlugin : IPlugin
    {
        protected string PluginName { get; }

        protected BasePlugin(string pluginName)
        {
            PluginName = pluginName;
        }

        public void Execute(IServiceProvider serviceProvider)
        {
            IPluginExecutionContext context = (IPluginExecutionContext)serviceProvider.GetService(typeof(IPluginExecutionContext));
            IOrganizationServiceFactory factory = (IOrganizationServiceFactory)serviceProvider.GetService(typeof(IOrganizationServiceFactory));
            IOrganizationService service = factory.CreateOrganizationService(context.UserId);
            ITracingService tracing = (ITracingService)serviceProvider.GetService(typeof(ITracingService));

            try
            {
                tracing.Trace($"{PluginName} execution started");
                ExecutePlugin(context, service, tracing);
                tracing.Trace($"{PluginName} execution completed");
            }
            catch (Exception ex)
            {
                tracing.Trace($"Error in {PluginName}: {ex.Message}");
                throw new InvalidPluginExecutionException($"Error in {PluginName}", ex);
            }
        }

        protected abstract void ExecutePlugin(IPluginExecutionContext context, IOrganizationService service, ITracingService tracing);

        protected Entity GetTargetEntity(IPluginExecutionContext context)
        {
            if (context.InputParameters.Contains("Target") && context.InputParameters["Target"] is Entity)
            {
                return (Entity)context.InputParameters["Target"];
            }
            return null;
        }
    }

    // Konkretny plugin używający dependency injection pattern
    public class AccountPreCreatePlugin : BasePlugin
    {
        private readonly IEntityValidator _validator;
        private readonly IAccountBusinessLogic _businessLogic;

        // Konstruktor bezparametrowy wymagany przez Dynamics 365
        public AccountPreCreatePlugin() : this(null, null)
        {
        }

        // Konstruktor z dependency injection (używany w testach)
        public AccountPreCreatePlugin(IEntityValidator validator, IAccountBusinessLogic businessLogic)
            : base("AccountPreCreatePlugin")
        {
            // Użyj przekazanych dependencies lub stwórz domyślne
            _validator = validator;
            _businessLogic = businessLogic;
        }

        protected override void ExecutePlugin(IPluginExecutionContext context, IOrganizationService service, ITracingService tracing)
        {
            Entity target = GetTargetEntity(context);
            if (target == null || target.LogicalName != "account")
            {
                return;
            }

            // Inicjalizuj dependencies jeśli nie zostały przekazane (production scenario)
            IEntityValidator validator = _validator ?? new AccountValidator();
            IAccountBusinessLogic businessLogic = _businessLogic ?? new AccountBusinessLogic(tracing);

            // Walidacja
            if (!validator.Validate(target))
            {
                string message = validator.GetValidationMessage();
                tracing.Trace($"Validation failed: {message}");
                throw new InvalidPluginExecutionException(message);
            }

            // Business logic
            businessLogic.SetDefaultValues(target);
            businessLogic.CalculateAccountRating(target, service);
        }
    }
}
```

> 💡 **TIP**: Ten wzorzec (abstract base + interfaces + dependency injection) pozwala na:
> - Łatwe testowanie (mock interfaces)
> - Reużywalność kodu (wspólna logika w base class)
> - Separację odpowiedzialności (validator, business logic)
> - Maintainability (łatwe dodawanie nowych walidacji/logiki)

---

## 1.3 LINQ i zapytania

LINQ (Language Integrated Query) to jedna z najpotężniejszych funkcji C# do przetwarzania kolekcji danych. W Dynamics 365 używamy LINQ zarówno do przetwarzania wyników zapytań jak i do budowania zapytań do bazy danych.

### Query syntax vs method syntax

LINQ oferuje dwie składnie: query syntax (podobny do SQL) i method syntax (łańcuchy metod).

```csharp
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Query;
using System;
using System.Collections.Generic;
using System.Linq;

namespace DynamicsExamples
{
    public class LinqExamples
    {
        public void CompareSyntaxes(List<Entity> accounts)
        {
            // QUERY SYNTAX (SQL-like)
            var activeAccountsQuery = from account in accounts
                                     where account.GetAttributeValue<OptionSetValue>("statecode")?.Value == 0
                                     orderby account.GetAttributeValue<string>("name")
                                     select account;

            // METHOD SYNTAX (fluent API)
            var activeAccountsMethod = accounts
                .Where(a => a.GetAttributeValue<OptionSetValue>("statecode")?.Value == 0)
                .OrderBy(a => a.GetAttributeValue<string>("name"));

            // Oba dają ten sam rezultat!

            // QUERY SYNTAX z projekcją
            var accountNamesQuery = from account in accounts
                                   where account.GetAttributeValue<OptionSetValue>("statecode")?.Value == 0
                                   select new
                                   {
                                       Name = account.GetAttributeValue<string>("name"),
                                       Revenue = account.GetAttributeValue<Money>("revenue")?.Value ?? 0
                                   };

            // METHOD SYNTAX z projekcją
            var accountNamesMethod = accounts
                .Where(a => a.GetAttributeValue<OptionSetValue>("statecode")?.Value == 0)
                .Select(a => new
                {
                    Name = a.GetAttributeValue<string>("name"),
                    Revenue = a.GetAttributeValue<Money>("revenue")?.Value ?? 0
                });
        }
    }
}
```

> 💡 **TIP**: Method syntax jest bardziej popularny w społeczności .NET i oferuje więcej możliwości. W tym poradniku będziemy używać głównie method syntax.

### Where, Select, GroupBy, Join

```csharp
using Microsoft.Xrm.Sdk;
using System;
using System.Collections.Generic;
using System.Linq;

namespace DynamicsExamples
{
    public class LinqOperations
    {
        // WHERE - filtrowanie
        public void DemonstrateWhere(List<Entity> accounts)
        {
            // Prosty where
            var activeAccounts = accounts.Where(a =>
                a.GetAttributeValue<OptionSetValue>("statecode")?.Value == 0);

            // Multiple conditions
            var premiumActiveAccounts = accounts.Where(a =>
                a.GetAttributeValue<OptionSetValue>("statecode")?.Value == 0 &&
                a.GetAttributeValue<Money>("revenue")?.Value > 1000000);

            // Złożone warunki
            var filteredAccounts = accounts.Where(a =>
            {
                decimal? revenue = a.GetAttributeValue<Money>("revenue")?.Value;
                int? category = a.GetAttributeValue<OptionSetValue>("accountcategorycode")?.Value;

                return revenue.HasValue && revenue.Value > 500000 && category == 1;
            });

            // Where z indexem
            var firstFiveAccounts = accounts.Where((a, index) => index < 5);
        }

        // SELECT - projekcja/transformacja
        public void DemonstrateSelect(List<Entity> accounts)
        {
            // Select pojedynczej właściwości
            List<string> accountNames = accounts
                .Select(a => a.GetAttributeValue<string>("name"))
                .ToList();

            // Select do anonymous type
            var accountSummaries = accounts.Select(a => new
            {
                Id = a.Id,
                Name = a.GetAttributeValue<string>("name"),
                Revenue = a.GetAttributeValue<Money>("revenue")?.Value ?? 0,
                IsActive = a.GetAttributeValue<OptionSetValue>("statecode")?.Value == 0
            }).ToList();

            // Select do konkretnego typu
            List<AccountDTO> accountDTOs = accounts.Select(a => new AccountDTO
            {
                AccountId = a.Id,
                AccountName = a.GetAttributeValue<string>("name"),
                TotalRevenue = a.GetAttributeValue<Money>("revenue")?.Value ?? 0
            }).ToList();

            // SelectMany - spłaszczanie kolekcji zagnieżdżonych
            // Przykład: wszystkie kontakty ze wszystkich accounts
            var allContacts = accounts.SelectMany(a => GetContactsForAccount(a));
        }

        // GROUP BY - grupowanie
        public void DemonstrateGroupBy(List<Entity> accounts)
        {
            // Grupowanie po kategorii
            var accountsByCategory = accounts
                .GroupBy(a => a.GetAttributeValue<OptionSetValue>("accountcategorycode")?.Value ?? 0)
                .ToList();

            foreach (var group in accountsByCategory)
            {
                Console.WriteLine($"Category {group.Key}: {group.Count()} accounts");
            }

            // Grupowanie z agregacją
            var categoryStats = accounts
                .GroupBy(a => a.GetAttributeValue<OptionSetValue>("accountcategorycode")?.Value ?? 0)
                .Select(g => new
                {
                    Category = g.Key,
                    Count = g.Count(),
                    TotalRevenue = g.Sum(a => a.GetAttributeValue<Money>("revenue")?.Value ?? 0),
                    AverageRevenue = g.Average(a => a.GetAttributeValue<Money>("revenue")?.Value ?? 0)
                })
                .ToList();

            // Grupowanie po wielu kluczach
            var accountsByStateAndCategory = accounts
                .GroupBy(a => new
                {
                    State = a.GetAttributeValue<OptionSetValue>("statecode")?.Value ?? 0,
                    Category = a.GetAttributeValue<OptionSetValue>("accountcategorycode")?.Value ?? 0
                })
                .Select(g => new
                {
                    g.Key.State,
                    g.Key.Category,
                    Count = g.Count()
                })
                .ToList();
        }

        // JOIN - łączenie kolekcji
        public void DemonstrateJoin(List<Entity> accounts, List<Entity> contacts)
        {
            // Inner join
            var accountsWithContacts = accounts.Join(
                contacts,
                account => account.Id,
                contact => contact.GetAttributeValue<EntityReference>("parentcustomerid")?.Id,
                (account, contact) => new
                {
                    AccountName = account.GetAttributeValue<string>("name"),
                    ContactName = contact.GetAttributeValue<string>("fullname"),
                    ContactEmail = contact.GetAttributeValue<string>("emailaddress1")
                }
            ).ToList();

            // Group join (left join)
            var accountsWithAllContacts = accounts.GroupJoin(
                contacts,
                account => account.Id,
                contact => contact.GetAttributeValue<EntityReference>("parentcustomerid")?.Id,
                (account, contactGroup) => new
                {
                    AccountName = account.GetAttributeValue<string>("name"),
                    ContactCount = contactGroup.Count(),
                    Contacts = contactGroup.Select(c => c.GetAttributeValue<string>("fullname")).ToList()
                }
            ).ToList();
        }

        // Helper methods
        private List<Entity> GetContactsForAccount(Entity account)
        {
            // Implementacja pobierania kontaktów
            return new List<Entity>();
        }
    }

    // DTO class
    public class AccountDTO
    {
        public Guid AccountId { get; set; }
        public string AccountName { get; set; }
        public decimal TotalRevenue { get; set; }
    }
}
```

### Deferred vs immediate execution

Zrozumienie różnicy między deferred (odroczone) i immediate (natychmiastowe) wykonanie jest kluczowe dla wydajności.

```csharp
using Microsoft.Xrm.Sdk;
using System;
using System.Collections.Generic;
using System.Linq;

namespace DynamicsExamples
{
    public class ExecutionTiming
    {
        public void DemonstrateDeferredExecution()
        {
            List<Entity> accounts = GetAccounts();

            // DEFERRED EXECUTION - zapytanie nie jest wykonane!
            var query = accounts.Where(a =>
                a.GetAttributeValue<Money>("revenue")?.Value > 100000);

            Console.WriteLine("Query created but not executed yet");

            // Modyfikacja źródłowej kolekcji
            Entity newAccount = new Entity("account");
            newAccount["revenue"] = new Money(200000);
            accounts.Add(newAccount);

            // TERAZ zapytanie jest wykonane (materialization)
            List<Entity> results = query.ToList();
            // results będzie zawierać nowego account'a!

            // Inne operacje powodujące immediate execution:
            int count = query.Count();           // Wykonuje zapytanie
            Entity first = query.FirstOrDefault(); // Wykonuje zapytanie
            bool any = query.Any();              // Wykonuje zapytanie
            decimal sum = query.Sum(a => a.GetAttributeValue<Money>("revenue")?.Value ?? 0); // Wykonuje
        }

        public void DemonstrateImmediateExecution()
        {
            List<Entity> accounts = GetAccounts();

            // IMMEDIATE EXECUTION - zapytanie wykonane natychmiast
            List<Entity> results = accounts
                .Where(a => a.GetAttributeValue<Money>("revenue")?.Value > 100000)
                .ToList(); // ToList() powoduje immediate execution

            // Modyfikacja źródłowej kolekcji NIE wpłynie na results
            Entity newAccount = new Entity("account");
            newAccount["revenue"] = new Money(200000);
            accounts.Add(newAccount);

            // results nadal ma stare dane
            Console.WriteLine($"Results count: {results.Count}"); // Nie zmieni się
        }

        public void PerformanceConsiderations(IOrganizationService service)
        {
            // ❌ ŹLE - Multiple executions!
            var query = GetAllAccounts(service)
                .Where(a => a.GetAttributeValue<Money>("revenue")?.Value > 100000);

            int count = query.Count();      // Wykonuje GetAllAccounts() + Where
            var first = query.First();       // Wykonuje GetAllAccounts() + Where PONOWNIE!
            var last = query.Last();         // Wykonuje GetAllAccounts() + Where JESZCZE RAZ!

            // ✅ DOBRZE - Single execution
            List<Entity> results = GetAllAccounts(service)
                .Where(a => a.GetAttributeValue<Money>("revenue")?.Value > 100000)
                .ToList(); // Wykonaj raz

            int count2 = results.Count;      // Z pamięci
            var first2 = results.First();     // Z pamięci
            var last2 = results.Last();       // Z pamięci
        }

        private List<Entity> GetAccounts()
        {
            return new List<Entity>();
        }

        private IEnumerable<Entity> GetAllAccounts(IOrganizationService service)
        {
            // Symulacja kosztownej operacji
            Console.WriteLine("Executing expensive query...");
            return new List<Entity>();
        }
    }
}
```

> ⚠️ **WARNING**: Deferred execution może prowadzić do wielokrotnego wykonywania kosztownych operacji. Użyj `.ToList()`, `.ToArray()` lub `.ToDictionary()` aby wykonać zapytanie raz i przechować wyniki w pamięci.

### Praktyczne przykłady w kontekście Dynamics

```csharp
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Query;
using System;
using System.Collections.Generic;
using System.Linq;

namespace DynamicsExamples
{
    public class DynamicsLinqExamples
    {
        private IOrganizationService _service;

        public DynamicsLinqExamples(IOrganizationService service)
        {
            _service = service;
        }

        // Przykład 1: Filtrowanie i sortowanie wyników zapytania
        public List<Entity> GetTopRevenueAccounts(int topCount)
        {
            // Pobierz wszystkie aktywne accounts
            QueryExpression query = new QueryExpression("account")
            {
                ColumnSet = new ColumnSet("name", "revenue", "accountcategorycode"),
                Criteria = new FilterExpression
                {
                    Conditions =
                    {
                        new ConditionExpression("statecode", ConditionOperator.Equal, 0)
                    }
                }
            };

            EntityCollection results = _service.RetrieveMultiple(query);

            // Użyj LINQ do przetworzenia wyników
            return results.Entities
                .Where(a => a.GetAttributeValue<Money>("revenue")?.Value > 0)
                .OrderByDescending(a => a.GetAttributeValue<Money>("revenue")?.Value)
                .Take(topCount)
                .ToList();
        }

        // Przykład 2: Agregacje
        public Dictionary<int, decimal> GetRevenueByCategory()
        {
            QueryExpression query = new QueryExpression("account")
            {
                ColumnSet = new ColumnSet("revenue", "accountcategorycode"),
                Criteria = new FilterExpression
                {
                    Conditions =
                    {
                        new ConditionExpression("statecode", ConditionOperator.Equal, 0)
                    }
                }
            };

            EntityCollection results = _service.RetrieveMultiple(query);

            // Grupowanie i sumowanie
            return results.Entities
                .Where(a => a.Contains("accountcategorycode") && a.Contains("revenue"))
                .GroupBy(a => a.GetAttributeValue<OptionSetValue>("accountcategorycode").Value)
                .ToDictionary(
                    g => g.Key,
                    g => g.Sum(a => a.GetAttributeValue<Money>("revenue")?.Value ?? 0)
                );
        }

        // Przykład 3: Transformacja do DTO
        public List<AccountSummaryDTO> GetAccountSummaries()
        {
            QueryExpression query = new QueryExpression("account")
            {
                ColumnSet = new ColumnSet("name", "revenue", "numberofemployees", "createdon")
            };

            EntityCollection results = _service.RetrieveMultiple(query);

            return results.Entities
                .Select(a => new AccountSummaryDTO
                {
                    Id = a.Id,
                    Name = a.GetAttributeValue<string>("name"),
                    Revenue = a.GetAttributeValue<Money>("revenue")?.Value ?? 0,
                    EmployeeCount = a.GetAttributeValue<int?>("numberofemployees") ?? 0,
                    CreatedDate = a.GetAttributeValue<DateTime>("createdon"),
                    Category = DetermineCategory(a.GetAttributeValue<Money>("revenue")?.Value ?? 0)
                })
                .OrderByDescending(dto => dto.Revenue)
                .ToList();
        }

        // Przykład 4: Złożone filtrowanie z multiple conditions
        public List<Entity> FindMatchingAccounts(AccountSearchCriteria criteria)
        {
            QueryExpression query = new QueryExpression("account")
            {
                ColumnSet = new ColumnSet(true)
            };

            EntityCollection results = _service.RetrieveMultiple(query);

            return results.Entities
                .Where(a =>
                {
                    // Name filter
                    if (!string.IsNullOrEmpty(criteria.NameContains))
                    {
                        string name = a.GetAttributeValue<string>("name");
                        if (string.IsNullOrEmpty(name) || !name.Contains(criteria.NameContains, StringComparison.OrdinalIgnoreCase))
                            return false;
                    }

                    // Revenue range filter
                    decimal? revenue = a.GetAttributeValue<Money>("revenue")?.Value;
                    if (criteria.MinRevenue.HasValue && (!revenue.HasValue || revenue.Value < criteria.MinRevenue.Value))
                        return false;
                    if (criteria.MaxRevenue.HasValue && (!revenue.HasValue || revenue.Value > criteria.MaxRevenue.Value))
                        return false;

                    // Category filter
                    if (criteria.Categories != null && criteria.Categories.Any())
                    {
                        int? category = a.GetAttributeValue<OptionSetValue>("accountcategorycode")?.Value;
                        if (!category.HasValue || !criteria.Categories.Contains(category.Value))
                            return false;
                    }

                    return true;
                })
                .ToList();
        }

        // Przykład 5: Distinct values
        public List<string> GetUniqueIndustries()
        {
            QueryExpression query = new QueryExpression("account")
            {
                ColumnSet = new ColumnSet("industrycode")
            };

            EntityCollection results = _service.RetrieveMultiple(query);

            return results.Entities
                .Where(a => a.Contains("industrycode"))
                .Select(a => a.FormattedValues["industrycode"])
                .Distinct()
                .OrderBy(industry => industry)
                .ToList();
        }

        // Przykład 6: Paging z LINQ
        public List<Entity> GetAccountsPage(int pageNumber, int pageSize)
        {
            QueryExpression query = new QueryExpression("account")
            {
                ColumnSet = new ColumnSet("name", "revenue", "createdon")
            };

            EntityCollection results = _service.RetrieveMultiple(query);

            return results.Entities
                .OrderBy(a => a.GetAttributeValue<string>("name"))
                .Skip((pageNumber - 1) * pageSize)
                .Take(pageSize)
                .ToList();
        }

        // Helper methods
        private string DetermineCategory(decimal revenue)
        {
            if (revenue >= 1000000) return "Enterprise";
            if (revenue >= 100000) return "Medium";
            return "Small";
        }
    }

    // DTO classes
    public class AccountSummaryDTO
    {
        public Guid Id { get; set; }
        public string Name { get; set; }
        public decimal Revenue { get; set; }
        public int EmployeeCount { get; set; }
        public DateTime CreatedDate { get; set; }
        public string Category { get; set; }
    }

    public class AccountSearchCriteria
    {
        public string NameContains { get; set; }
        public decimal? MinRevenue { get; set; }
        public decimal? MaxRevenue { get; set; }
        public List<int> Categories { get; set; }
    }
}
```

### Anti-patterns z LINQ

```csharp
using Microsoft.Xrm.Sdk;
using System.Collections.Generic;
using System.Linq;

namespace DynamicsExamples
{
    public class LinqAntiPatterns
    {
        // ❌ ŹLE: Wielokrotne iteracje przez tę samą kolekcję
        public void BadMultipleIterations(List<Entity> accounts)
        {
            int totalCount = accounts.Count();
            int activeCount = accounts.Count(a => a.GetAttributeValue<OptionSetValue>("statecode")?.Value == 0);
            int inactiveCount = accounts.Count(a => a.GetAttributeValue<OptionSetValue>("statecode")?.Value == 1);
            decimal totalRevenue = accounts.Sum(a => a.GetAttributeValue<Money>("revenue")?.Value ?? 0);
            // 4 iteracje przez całą kolekcję!
        }

        // ✅ DOBRZE: Jedna iteracja
        public void GoodSingleIteration(List<Entity> accounts)
        {
            var stats = accounts.Aggregate(
                new { TotalCount = 0, ActiveCount = 0, InactiveCount = 0, TotalRevenue = 0m },
                (acc, account) => new
                {
                    TotalCount = acc.TotalCount + 1,
                    ActiveCount = acc.ActiveCount + (account.GetAttributeValue<OptionSetValue>("statecode")?.Value == 0 ? 1 : 0),
                    InactiveCount = acc.InactiveCount + (account.GetAttributeValue<OptionSetValue>("statecode")?.Value == 1 ? 1 : 0),
                    TotalRevenue = acc.TotalRevenue + (account.GetAttributeValue<Money>("revenue")?.Value ?? 0)
                }
            );
            // Tylko 1 iteracja!
        }

        // ❌ ŹLE: Używanie ToList() zbyt wcześnie
        public List<string> BadEarlyMaterialization(List<Entity> accounts)
        {
            return accounts
                .ToList()                    // Niepotrzebne ToList()
                .Where(a => a.GetAttributeValue<OptionSetValue>("statecode")?.Value == 0)
                .ToList()                    // Niepotrzebne ToList()
                .Select(a => a.GetAttributeValue<string>("name"))
                .ToList();
        }

        // ✅ DOBRZE: Materialization na końcu
        public List<string> GoodLateMaterialization(List<Entity> accounts)
        {
            return accounts
                .Where(a => a.GetAttributeValue<OptionSetValue>("statecode")?.Value == 0)
                .Select(a => a.GetAttributeValue<string>("name"))
                .ToList();                   // Tylko jedno ToList() na końcu
        }

        // ❌ ŹLE: Używanie Where przed OrderBy gdy nie jest potrzebne
        public List<Entity> BadWhereOrderBy(List<Entity> accounts)
        {
            return accounts
                .OrderBy(a => a.GetAttributeValue<string>("name"))    // Sortuje WSZYSTKIE
                .Where(a => a.GetAttributeValue<OptionSetValue>("statecode")?.Value == 0)  // Potem filtruje
                .ToList();
        }

        // ✅ DOBRZE: Where przed OrderBy
        public List<Entity> GoodWhereOrderBy(List<Entity> accounts)
        {
            return accounts
                .Where(a => a.GetAttributeValue<OptionSetValue>("statecode")?.Value == 0)  // Filtruj najpierw
                .OrderBy(a => a.GetAttributeValue<string>("name"))    // Sortuj mniej elementów
                .ToList();
        }

        // ❌ ŹLE: Any() zamiast Count() dla sprawdzenia czy kolekcja jest pusta
        public bool BadCountCheck(List<Entity> accounts)
        {
            return accounts.Count() > 0;     // Liczy wszystkie elementy
        }

        // ✅ DOBRZE: Any() dla sprawdzenia istnienia
        public bool GoodAnyCheck(List<Entity> accounts)
        {
            return accounts.Any();           // Zwraca true przy pierwszym elemencie
        }

        // ❌ ŹLE: FirstOrDefault() + null check zamiast Any()
        public bool BadFirstOrDefaultCheck(List<Entity> accounts, string name)
        {
            return accounts.FirstOrDefault(a => a.GetAttributeValue<string>("name") == name) != null;
        }

        // ✅ DOBRZE: Any() z predykatem
        public bool GoodAnyWithPredicate(List<Entity> accounts, string name)
        {
            return accounts.Any(a => a.GetAttributeValue<string>("name") == name);
        }
    }
}
```

> 💡 **TIP**: Profil performance LINQ queries używając StopWatch lub Application Insights w produkcji.

---

## 1.4 Async/Await

Asynchroniczne programowanie jest kluczowe dla operacji I/O-bound (takich jak wywołania API, operacje bazodanowe). W Dynamics 365 używamy async/await w custom kod actions, web resources, oraz integracjach.

### Task i Task<T>

`Task` reprezentuje asynchroniczną operację. `Task<T>` reprezentuje asynchroniczną operację zwracającą wartość typu `T`.

```csharp
using Microsoft.Xrm.Sdk;
using System;
using System.Net.Http;
using System.Threading.Tasks;

namespace DynamicsExamples
{
    public class TaskExamples
    {
        private IOrganizationService _service;

        public TaskExamples(IOrganizationService service)
        {
            _service = service;
        }

        // Task - operacja async bez return value
        public async Task UpdateAccountAsync(Guid accountId, string newName)
        {
            // Symulacja async operation
            await Task.Delay(100);

            Entity account = new Entity("account", accountId);
            account["name"] = newName;

            _service.Update(account);
        }

        // Task<T> - operacja async zwracająca wartość
        public async Task<Entity> GetAccountAsync(Guid accountId)
        {
            // Symulacja async operation
            await Task.Delay(100);

            return _service.Retrieve("account", accountId, new Microsoft.Xrm.Sdk.Query.ColumnSet(true));
        }

        // Task<T> z HttpClient (typowy przykład)
        public async Task<string> CallExternalAPIAsync(string url)
        {
            using (HttpClient client = new HttpClient())
            {
                HttpResponseMessage response = await client.GetAsync(url);
                response.EnsureSuccessStatusCode();

                string content = await response.Content.ReadAsStringAsync();
                return content;
            }
        }

        // Void async - UNIKAJ! (tylko dla event handlers)
        public async void BadAsyncVoid() // ❌ Nie używaj!
        {
            await Task.Delay(1000);
            // Wyjątki w async void są trudne do złapania
        }

        // Task async - poprawna forma
        public async Task GoodAsyncTask() // ✅ Używaj tego
        {
            await Task.Delay(1000);
            // Wyjątki można złapać i obsłużyć
        }
    }
}
```

> ⚠️ **WARNING**: Nigdy nie używaj `async void` poza event handlerami! Wyjątki w async void nie mogą być złapane przez try-catch i crashują aplikację.

### Async/await pattern

```csharp
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Query;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;

namespace DynamicsExamples
{
    public class AsyncAwaitPatterns
    {
        private IOrganizationService _service;

        public AsyncAwaitPatterns(IOrganizationService service)
        {
            _service = service;
        }

        // Podstawowy async/await pattern
        public async Task<decimal> CalculateTotalRevenueAsync()
        {
            // Pobierz accounts asynchronicznie (symulacja)
            List<Entity> accounts = await GetAllAccountsAsync();

            // Przetworzenie synchroniczne (LINQ)
            decimal totalRevenue = accounts
                .Where(a => a.Contains("revenue"))
                .Sum(a => a.GetAttributeValue<Money>("revenue")?.Value ?? 0);

            return totalRevenue;
        }

        // Sequential async operations (jedna po drugiej)
        public async Task<Entity> CreateAccountWithContactAsync(string accountName, string contactName)
        {
            // Najpierw stwórz account
            Entity account = new Entity("account");
            account["name"] = accountName;
            Guid accountId = _service.Create(account);

            // Poczekaj na external validation (async)
            bool isValid = await ValidateAccountExternallyAsync(accountId);
            if (!isValid)
            {
                throw new InvalidOperationException("Account validation failed");
            }

            // Potem stwórz contact
            Entity contact = new Entity("contact");
            contact["firstname"] = contactName;
            contact["parentcustomerid"] = new EntityReference("account", accountId);
            _service.Create(contact);

            // Pobierz i zwróć utworzony account
            return await GetAccountAsync(accountId);
        }

        // Parallel async operations (równolegle)
        public async Task<(List<Entity> accounts, List<Entity> contacts)> GetAccountsAndContactsAsync()
        {
            // Uruchom oba zapytania równolegle
            Task<List<Entity>> accountsTask = GetAllAccountsAsync();
            Task<List<Entity>> contactsTask = GetAllContactsAsync();

            // Poczekaj na oba
            await Task.WhenAll(accountsTask, contactsTask);

            // Pobierz wyniki
            List<Entity> accounts = await accountsTask;
            List<Entity> contacts = await contactsTask;

            return (accounts, contacts);
        }

        // Task.WhenAll - czekaj na wszystkie tasks
        public async Task<List<Entity>> GetMultipleEntitiesAsync(List<Guid> ids)
        {
            // Stwórz task dla każdego ID
            List<Task<Entity>> tasks = ids
                .Select(id => GetAccountAsync(id))
                .ToList();

            // Czekaj na wszystkie i zwróć wyniki
            Entity[] results = await Task.WhenAll(tasks);
            return results.ToList();
        }

        // Task.WhenAny - czekaj na pierwszy ukończony
        public async Task<Entity> GetFirstAvailableAccountAsync(List<string> sources)
        {
            // Stwórz task dla każdego źródła
            List<Task<Entity>> tasks = sources
                .Select(source => GetAccountFromSourceAsync(source))
                .ToList();

            // Zwróć pierwszą ukończoną
            Task<Entity> firstCompleted = await Task.WhenAny(tasks);
            return await firstCompleted;
        }

        // ConfigureAwait(false) dla library code
        public async Task<Entity> LibraryMethodAsync(Guid accountId)
        {
            // W library code używamy ConfigureAwait(false)
            // aby uniknąć przechwytywania kontekstu synchronizacji
            Entity account = await GetAccountAsync(accountId).ConfigureAwait(false);

            // Dalsze operacje
            await ProcessAccountAsync(account).ConfigureAwait(false);

            return account;
        }

        // Helper methods (symulacje async operations)
        private async Task<List<Entity>> GetAllAccountsAsync()
        {
            await Task.Delay(100); // Symulacja async operation

            QueryExpression query = new QueryExpression("account")
            {
                ColumnSet = new ColumnSet(true)
            };

            return _service.RetrieveMultiple(query).Entities.ToList();
        }

        private async Task<List<Entity>> GetAllContactsAsync()
        {
            await Task.Delay(100);

            QueryExpression query = new QueryExpression("contact")
            {
                ColumnSet = new ColumnSet(true)
            };

            return _service.RetrieveMultiple(query).Entities.ToList();
        }

        private async Task<Entity> GetAccountAsync(Guid accountId)
        {
            await Task.Delay(50);
            return _service.Retrieve("account", accountId, new ColumnSet(true));
        }

        private async Task<bool> ValidateAccountExternallyAsync(Guid accountId)
        {
            await Task.Delay(200);
            return true; // Symulacja external validation
        }

        private async Task<Entity> GetAccountFromSourceAsync(string source)
        {
            await Task.Delay(new Random().Next(100, 500));
            return new Entity("account");
        }

        private async Task ProcessAccountAsync(Entity account)
        {
            await Task.Delay(100);
        }
    }
}
```

### Obsługa błędów w async code

```csharp
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;

namespace DynamicsExamples
{
    public class AsyncErrorHandling
    {
        // Try-catch w async methods
        public async Task<string> SafeApiCallAsync(string url)
        {
            try
            {
                using (HttpClient client = new HttpClient())
                {
                    HttpResponseMessage response = await client.GetAsync(url);
                    response.EnsureSuccessStatusCode();

                    return await response.Content.ReadAsStringAsync();
                }
            }
            catch (HttpRequestException ex)
            {
                // Obsłuż błąd HTTP
                Console.WriteLine($"HTTP Error: {ex.Message}");
                throw; // Re-throw jeśli chcesz propagować błąd
            }
            catch (TaskCanceledException ex)
            {
                // Obsłuż timeout
                Console.WriteLine($"Timeout: {ex.Message}");
                return null;
            }
            catch (Exception ex)
            {
                // Obsłuż inne błędy
                Console.WriteLine($"Unexpected error: {ex.Message}");
                throw;
            }
        }

        // Obsługa błędów w Task.WhenAll
        public async Task<List<string>> GetMultipleResultsAsync(List<string> urls)
        {
            List<Task<string>> tasks = new List<Task<string>>();

            foreach (string url in urls)
            {
                tasks.Add(SafeApiCallAsync(url));
            }

            try
            {
                // WhenAll rzuca wyjątek jeśli którykolwiek task failed
                string[] results = await Task.WhenAll(tasks);
                return new List<string>(results);
            }
            catch (Exception ex)
            {
                // Sprawdź które tasks failed
                foreach (Task<string> task in tasks)
                {
                    if (task.IsFaulted)
                    {
                        Console.WriteLine($"Task failed: {task.Exception?.GetBaseException().Message}");
                    }
                }

                throw;
            }
        }

        // Retry pattern dla async operations
        public async Task<T> RetryAsync<T>(
            Func<Task<T>> operation,
            int maxRetries = 3,
            int delayMilliseconds = 1000)
        {
            int retryCount = 0;

            while (true)
            {
                try
                {
                    return await operation();
                }
                catch (Exception ex)
                {
                    retryCount++;

                    if (retryCount >= maxRetries)
                    {
                        Console.WriteLine($"Operation failed after {maxRetries} retries");
                        throw;
                    }

                    Console.WriteLine($"Operation failed, retrying ({retryCount}/{maxRetries})...");
                    await Task.Delay(delayMilliseconds * retryCount); // Exponential backoff
                }
            }
        }

        // Użycie retry pattern
        public async Task<string> CallApiWithRetryAsync(string url)
        {
            return await RetryAsync(
                async () =>
                {
                    using (HttpClient client = new HttpClient())
                    {
                        HttpResponseMessage response = await client.GetAsync(url);
                        response.EnsureSuccessStatusCode();
                        return await response.Content.ReadAsStringAsync();
                    }
                },
                maxRetries: 3,
                delayMilliseconds: 1000
            );
        }

        // Timeout pattern
        public async Task<T> WithTimeoutAsync<T>(Task<T> task, int timeoutMilliseconds)
        {
            Task delayTask = Task.Delay(timeoutMilliseconds);
            Task completedTask = await Task.WhenAny(task, delayTask);

            if (completedTask == delayTask)
            {
                throw new TimeoutException($"Operation timed out after {timeoutMilliseconds}ms");
            }

            return await task;
        }

        // Użycie timeout pattern
        public async Task<string> CallApiWithTimeoutAsync(string url)
        {
            using (HttpClient client = new HttpClient())
            {
                Task<string> apiCall = client.GetStringAsync(url);
                return await WithTimeoutAsync(apiCall, 5000); // 5 second timeout
            }
        }
    }
}
```

> 💡 **TIP**: Zawsze używaj try-catch w async methods, szczególnie gdy wywołujesz external APIs lub wykonujesz operacje I/O.

### Praktyczne przykłady w Dynamics 365

```csharp
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Query;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

namespace DynamicsExamples
{
    // Przykład 1: Custom API Action z async operations
    public class AccountEnrichmentAction
    {
        public async Task<bool> EnrichAccountDataAsync(
            IOrganizationService service,
            ITracingService tracing,
            Guid accountId)
        {
            try
            {
                tracing.Trace("Starting account enrichment");

                // Pobierz account
                Entity account = service.Retrieve("account", accountId, new ColumnSet("name", "websiteurl"));
                string companyName = account.GetAttributeValue<string>("name");
                string website = account.GetAttributeValue<string>("websiteurl");

                // Wywołaj external API asynchronicznie
                tracing.Trace("Calling external enrichment API");
                CompanyData enrichmentData = await CallEnrichmentAPIAsync(companyName, website);

                // Update account z nowymi danymi
                Entity updateAccount = new Entity("account", accountId);
                updateAccount["numberofemployees"] = enrichmentData.EmployeeCount;
                updateAccount["revenue"] = new Money(enrichmentData.AnnualRevenue);
                updateAccount["industrycode"] = new OptionSetValue(enrichmentData.IndustryCode);

                service.Update(updateAccount);

                tracing.Trace("Account enrichment completed successfully");
                return true;
            }
            catch (Exception ex)
            {
                tracing.Trace($"Error during enrichment: {ex.Message}");
                return false;
            }
        }

        private async Task<CompanyData> CallEnrichmentAPIAsync(string companyName, string website)
        {
            using (HttpClient client = new HttpClient())
            {
                client.BaseAddress = new Uri("https://api.enrichment.example.com");
                client.DefaultRequestHeaders.Add("Authorization", "Bearer YOUR_API_KEY");

                var requestBody = new
                {
                    company_name = companyName,
                    website = website
                };

                string json = JsonSerializer.Serialize(requestBody);
                HttpContent content = new StringContent(json, Encoding.UTF8, "application/json");

                HttpResponseMessage response = await client.PostAsync("/v1/enrich", content);
                response.EnsureSuccessStatusCode();

                string responseJson = await response.Content.ReadAsStringAsync();
                return JsonSerializer.Deserialize<CompanyData>(responseJson);
            }
        }
    }

    // Przykład 2: Bulk operations z async
    public class BulkAccountProcessor
    {
        private IOrganizationService _service;
        private ITracingService _tracing;

        public BulkAccountProcessor(IOrganizationService service, ITracingService tracing)
        {
            _service = service;
            _tracing = tracing;
        }

        public async Task ProcessAccountsInBatchesAsync(List<Guid> accountIds, int batchSize = 10)
        {
            _tracing.Trace($"Processing {accountIds.Count} accounts in batches of {batchSize}");

            // Podziel na batche
            List<List<Guid>> batches = accountIds
                .Select((id, index) => new { id, index })
                .GroupBy(x => x.index / batchSize)
                .Select(g => g.Select(x => x.id).ToList())
                .ToList();

            int batchNumber = 0;
            foreach (List<Guid> batch in batches)
            {
                batchNumber++;
                _tracing.Trace($"Processing batch {batchNumber}/{batches.Count}");

                // Przetwórz batch równolegle
                List<Task> tasks = batch
                    .Select(id => ProcessSingleAccountAsync(id))
                    .ToList();

                await Task.WhenAll(tasks);

                _tracing.Trace($"Batch {batchNumber} completed");
            }

            _tracing.Trace("All batches processed");
        }

        private async Task ProcessSingleAccountAsync(Guid accountId)
        {
            try
            {
                // Symulacja async processing
                await Task.Delay(100);

                Entity account = _service.Retrieve("account", accountId, new ColumnSet("name"));

                // Process account
                Entity update = new Entity("account", accountId);
                update["description"] = $"Processed on {DateTime.Now:yyyy-MM-dd HH:mm:ss}";
                _service.Update(update);
            }
            catch (Exception ex)
            {
                _tracing.Trace($"Error processing account {accountId}: {ex.Message}");
            }
        }
    }

    // Przykład 3: Multiple API calls z aggregation
    public class MultiSourceDataAggregator
    {
        public async Task<AggregatedAccountData> AggregateAccountDataAsync(string accountName)
        {
            // Wywołaj multiple APIs równolegle
            Task<CompanyData> enrichmentTask = GetEnrichmentDataAsync(accountName);
            Task<CreditScore> creditTask = GetCreditScoreAsync(accountName);
            Task<List<NewsArticle>> newsTask = GetNewsArticlesAsync(accountName);

            // Czekaj na wszystkie
            await Task.WhenAll(enrichmentTask, creditTask, newsTask);

            // Aggregate results
            return new AggregatedAccountData
            {
                CompanyInfo = await enrichmentTask,
                CreditScore = await creditTask,
                RecentNews = await newsTask
            };
        }

        private async Task<CompanyData> GetEnrichmentDataAsync(string companyName)
        {
            await Task.Delay(200); // Symulacja API call
            return new CompanyData { EmployeeCount = 100, AnnualRevenue = 1000000, IndustryCode = 1 };
        }

        private async Task<CreditScore> GetCreditScoreAsync(string companyName)
        {
            await Task.Delay(300); // Symulacja API call
            return new CreditScore { Score = 750, Rating = "Good" };
        }

        private async Task<List<NewsArticle>> GetNewsArticlesAsync(string companyName)
        {
            await Task.Delay(150); // Symulacja API call
            return new List<NewsArticle>();
        }
    }

    // DTOs
    public class CompanyData
    {
        public int EmployeeCount { get; set; }
        public decimal AnnualRevenue { get; set; }
        public int IndustryCode { get; set; }
    }

    public class CreditScore
    {
        public int Score { get; set; }
        public string Rating { get; set; }
    }

    public class NewsArticle
    {
        public string Title { get; set; }
        public DateTime PublishedDate { get; set; }
    }

    public class AggregatedAccountData
    {
        public CompanyData CompanyInfo { get; set; }
        public CreditScore CreditScore { get; set; }
        public List<NewsArticle> RecentNews { get; set; }
    }
}
```

### Anti-patterns async/await

```csharp
using System;
using System.Threading.Tasks;

namespace DynamicsExamples
{
    public class AsyncAntiPatterns
    {
        // ❌ ŹLE: async void
        public async void BadAsyncVoid()
        {
            await Task.Delay(1000);
            throw new Exception("This will crash the app!");
        }

        // ✅ DOBRZE: async Task
        public async Task GoodAsyncTask()
        {
            await Task.Delay(1000);
            throw new Exception("This can be caught");
        }

        // ❌ ŹLE: .Result lub .Wait() (blocking)
        public void BadBlockingCall()
        {
            Task<string> task = GetDataAsync();
            string result = task.Result; // DEADLOCK risk!
        }

        // ✅ DOBRZE: await
        public async Task<string> GoodAwaitCall()
        {
            string result = await GetDataAsync();
            return result;
        }

        // ❌ ŹLE: async without await
        public async Task<string> BadAsyncWithoutAwait()
        {
            return "result"; // Warning CS1998
        }

        // ✅ DOBRZE: Remove async if not awaiting
        public Task<string> GoodSyncMethod()
        {
            return Task.FromResult("result");
        }

        // ❌ ŹLE: Niepotrzebny async/await (overhead)
        public async Task<string> BadUnnecessaryAsync()
        {
            return await GetDataAsync(); // Niepotrzebny await
        }

        // ✅ DOBRZE: Return task directly
        public Task<string> GoodDirectReturn()
        {
            return GetDataAsync(); // Brak niepotrzebnego overhead
        }

        // ❌ ŹLE: Async w konstruktorze (niemożliwe)
        public class BadAsyncConstructor
        {
            public BadAsyncConstructor()
            {
                // Nie można użyć await w konstruktorze!
                // InitializeAsync().Wait(); // Deadlock risk
            }

            private async Task InitializeAsync()
            {
                await Task.Delay(1000);
            }
        }

        // ✅ DOBRZE: Factory pattern dla async initialization
        public class GoodAsyncInitialization
        {
            private GoodAsyncInitialization()
            {
                // Private constructor
            }

            public static async Task<GoodAsyncInitialization> CreateAsync()
            {
                var instance = new GoodAsyncInitialization();
                await instance.InitializeAsync();
                return instance;
            }

            private async Task InitializeAsync()
            {
                await Task.Delay(1000);
            }
        }

        private async Task<string> GetDataAsync()
        {
            await Task.Delay(100);
            return "data";
        }
    }
}
```

> ⚠️ **WARNING**: Nigdy nie używaj `.Result` ani `.Wait()` w async code - prowadzi do deadlocków! Zawsze używaj `await`.

---

## 1.5 Dependency Injection

Dependency Injection (DI) to pattern projektowy, który promuje luźne powiązanie (loose coupling) między komponentami. W Dynamics 365 DI jest kluczowy dla testowalności pluginów i rozszerzeń.

### IoC containers

Inversion of Control (IoC) container zarządza tworzeniem obiektów i ich zależnościami.

```csharp
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Xrm.Sdk;
using System;

namespace DynamicsExamples
{
    // Przykład setup IoC container (np. w Azure Function lub custom app)
    public class DependencyInjectionSetup
    {
        public IServiceProvider ConfigureServices()
        {
            var services = new ServiceCollection();

            // Rejestracja serwisów
            services.AddSingleton<IAccountValidator, AccountValidator>();
            services.AddScoped<IAccountRepository, AccountRepository>();
            services.AddTransient<IEmailService, EmailService>();

            // Rejestracja z factory method
            services.AddScoped<IOrganizationService>(sp =>
            {
                // W real scenario: użyj CrmServiceClient
                return CreateOrganizationService();
            });

            return services.BuildServiceProvider();
        }

        private IOrganizationService CreateOrganizationService()
        {
            // Implementacja tworzenia service
            return null; // Placeholder
        }
    }

    // Interfaces
    public interface IAccountValidator
    {
        bool Validate(Entity account);
    }

    public interface IAccountRepository
    {
        Entity GetAccount(Guid id);
        void SaveAccount(Entity account);
    }

    public interface IEmailService
    {
        void SendEmail(string to, string subject, string body);
    }

    // Implementations
    public class AccountValidator : IAccountValidator
    {
        public bool Validate(Entity account)
        {
            return !string.IsNullOrWhiteSpace(account.GetAttributeValue<string>("name"));
        }
    }

    public class AccountRepository : IAccountRepository
    {
        private readonly IOrganizationService _service;

        public AccountRepository(IOrganizationService service)
        {
            _service = service;
        }

        public Entity GetAccount(Guid id)
        {
            return _service.Retrieve("account", id, new Microsoft.Xrm.Sdk.Query.ColumnSet(true));
        }

        public void SaveAccount(Entity account)
        {
            if (account.Id == Guid.Empty)
                _service.Create(account);
            else
                _service.Update(account);
        }
    }

    public class EmailService : IEmailService
    {
        private readonly IOrganizationService _service;

        public EmailService(IOrganizationService service)
        {
            _service = service;
        }

        public void SendEmail(string to, string subject, string body)
        {
            Entity email = new Entity("email");
            email["to"] = to;
            email["subject"] = subject;
            email["description"] = body;

            _service.Create(email);
        }
    }
}
```

### Service lifetime (Singleton, Scoped, Transient)

```csharp
using Microsoft.Extensions.DependencyInjection;
using System;

namespace DynamicsExamples
{
    public class ServiceLifetimeExamples
    {
        public void DemonstrateLifetimes()
        {
            var services = new ServiceCollection();

            // SINGLETON - jedna instancja przez cały czas życia aplikacji
            // Użyj dla: stateless services, cache, configuration
            services.AddSingleton<ICacheService, CacheService>();

            // SCOPED - jedna instancja per request/scope
            // Użyj dla: database contexts, per-request services
            services.AddScoped<IAccountRepository, AccountRepository>();

            // TRANSIENT - nowa instancja przy każdym request
            // Użyj dla: lightweight, stateless services
            services.AddTransient<IEmailService, EmailService>();

            IServiceProvider provider = services.BuildServiceProvider();

            // Demonstracja różnic
            using (IServiceScope scope1 = provider.CreateScope())
            {
                var cache1 = scope1.ServiceProvider.GetService<ICacheService>();
                var repo1a = scope1.ServiceProvider.GetService<IAccountRepository>();
                var repo1b = scope1.ServiceProvider.GetService<IAccountRepository>();
                var email1a = scope1.ServiceProvider.GetService<IEmailService>();
                var email1b = scope1.ServiceProvider.GetService<IEmailService>();

                // cache1 - ta sama instancja w całej aplikacji
                // repo1a == repo1b (ten sam scope)
                // email1a != email1b (zawsze nowa instancja)
            }

            using (IServiceScope scope2 = provider.CreateScope())
            {
                var cache2 = scope2.ServiceProvider.GetService<ICacheService>();
                var repo2 = scope2.ServiceProvider.GetService<IAccountRepository>();

                // cache1 == cache2 (Singleton)
                // repo1a != repo2 (różne scopes)
            }
        }
    }

    // Service interfaces
    public interface ICacheService
    {
        void Set(string key, object value);
        object Get(string key);
    }

    public class CacheService : ICacheService
    {
        private readonly System.Collections.Generic.Dictionary<string, object> _cache;

        public CacheService()
        {
            _cache = new System.Collections.Generic.Dictionary<string, object>();
            Console.WriteLine("CacheService created");
        }

        public void Set(string key, object value)
        {
            _cache[key] = value;
        }

        public object Get(string key)
        {
            return _cache.ContainsKey(key) ? _cache[key] : null;
        }
    }
}
```

**Porównanie lifetimes:**

| Lifetime | Kiedy tworzona | Kiedy niszczona | Użyj dla |
|----------|---------------|-----------------|----------|
| **Singleton** | Pierwszy request | Koniec aplikacji | Cache, Configuration, Stateless services |
| **Scoped** | Początek scope | Koniec scope | Database contexts, Request-specific services |
| **Transient** | Każdy request | Gdy garbage collected | Lightweight services, Stateless operations |

### Constructor injection

Constructor injection to najbardziej popularny sposób DI - zależności są przekazywane przez konstruktor.

```csharp
using Microsoft.Xrm.Sdk;
using System;
using System.Collections.Generic;

namespace DynamicsExamples
{
    // Przykład 1: Prosty constructor injection
    public class AccountBusinessLogic
    {
        private readonly IOrganizationService _service;
        private readonly ITracingService _tracing;
        private readonly IAccountValidator _validator;

        // Wszystkie zależności w konstruktorze
        public AccountBusinessLogic(
            IOrganizationService service,
            ITracingService tracing,
            IAccountValidator validator)
        {
            _service = service ?? throw new ArgumentNullException(nameof(service));
            _tracing = tracing ?? throw new ArgumentNullException(nameof(tracing));
            _validator = validator ?? throw new ArgumentNullException(nameof(validator));
        }

        public void ProcessAccount(Entity account)
        {
            _tracing.Trace("Starting account processing");

            if (!_validator.Validate(account))
            {
                throw new InvalidPluginExecutionException("Account validation failed");
            }

            // Business logic
            _service.Update(account);

            _tracing.Trace("Account processing completed");
        }
    }

    // Przykład 2: Plugin z DI (hybrid approach)
    public class AccountPlugin : IPlugin
    {
        // Dependencies które mogą być mockowane w testach
        private readonly IAccountValidator _validator;
        private readonly IAccountRepository _repository;

        // Konstruktor bezparametrowy wymagany przez Dynamics
        public AccountPlugin() : this(null, null)
        {
        }

        // Konstruktor dla testów z DI
        public AccountPlugin(IAccountValidator validator, IAccountRepository repository)
        {
            _validator = validator;
            _repository = repository;
        }

        public void Execute(IServiceProvider serviceProvider)
        {
            // Pobierz Dynamics services
            IPluginExecutionContext context = (IPluginExecutionContext)serviceProvider.GetService(typeof(IPluginExecutionContext));
            IOrganizationServiceFactory factory = (IOrganizationServiceFactory)serviceProvider.GetService(typeof(IOrganizationServiceFactory));
            IOrganizationService service = factory.CreateOrganizationService(context.UserId);
            ITracingService tracing = (ITracingService)serviceProvider.GetService(typeof(ITracingService));

            // Utwórz dependencies jeśli nie zostały wstrzyknięte (production)
            IAccountValidator validator = _validator ?? new AccountValidator();
            IAccountRepository repository = _repository ?? new AccountRepository(service);

            // Użyj dependencies
            Entity target = GetTarget(context);

            if (!validator.Validate(target))
            {
                throw new InvalidPluginExecutionException("Validation failed");
            }

            repository.SaveAccount(target);
        }

        private Entity GetTarget(IPluginExecutionContext context)
        {
            if (context.InputParameters.Contains("Target") && context.InputParameters["Target"] is Entity)
            {
                return (Entity)context.InputParameters["Target"];
            }
            return null;
        }
    }

    // Przykład 3: Service z multiple dependencies
    public class ComplexAccountService
    {
        private readonly IOrganizationService _service;
        private readonly IAccountValidator _validator;
        private readonly IAccountRepository _repository;
        private readonly IEmailService _emailService;
        private readonly ICacheService _cache;
        private readonly ITracingService _tracing;

        public ComplexAccountService(
            IOrganizationService service,
            IAccountValidator validator,
            IAccountRepository repository,
            IEmailService emailService,
            ICacheService cache,
            ITracingService tracing)
        {
            _service = service;
            _validator = validator;
            _repository = repository;
            _emailService = emailService;
            _cache = cache;
            _tracing = tracing;
        }

        public void CreateAccountWithNotification(Entity account, string notificationEmail)
        {
            _tracing.Trace("Creating account with notification");

            // Validate
            if (!_validator.Validate(account))
            {
                throw new ArgumentException("Invalid account");
            }

            // Check cache
            string cacheKey = $"account_{account.GetAttributeValue<string>("name")}";
            if (_cache.Get(cacheKey) != null)
            {
                _tracing.Trace("Account already exists in cache");
                return;
            }

            // Save
            _repository.SaveAccount(account);

            // Cache
            _cache.Set(cacheKey, account.Id);

            // Notify
            _emailService.SendEmail(
                notificationEmail,
                "New Account Created",
                $"Account {account.GetAttributeValue<string>("name")} was created"
            );

            _tracing.Trace("Account created successfully");
        }
    }
}
```

> 💡 **TIP**: Zawsze waliduj dependencies w konstruktorze (throw ArgumentNullException jeśli null). To zapewnia że obiekt nigdy nie będzie w nieprawidłowym stanie.

### Praktyczne przykłady dla Dynamics 365

```csharp
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Query;
using System;
using System.Collections.Generic;
using System.Linq;

namespace DynamicsExamples.DependencyInjection
{
    // ============================================================================
    // WARSTWA 1: INTERFACES (Contracts)
    // ============================================================================

    public interface IEntityValidator<T> where T : Entity
    {
        ValidationResult Validate(T entity);
    }

    public interface IRepository<T> where T : Entity
    {
        T GetById(Guid id);
        List<T> GetAll();
        void Save(T entity);
        void Delete(Guid id);
    }

    public interface IBusinessLogic<T> where T : Entity
    {
        void ProcessEntity(T entity);
    }

    public interface INotificationService
    {
        void NotifySuccess(string message);
        void NotifyError(string message, Exception ex);
    }

    // ============================================================================
    // WARSTWA 2: IMPLEMENTATIONS
    // ============================================================================

    // Account Validator
    public class AccountValidator : IEntityValidator<Entity>
    {
        private readonly ITracingService _tracing;

        public AccountValidator(ITracingService tracing)
        {
            _tracing = tracing;
        }

        public ValidationResult Validate(Entity account)
        {
            var result = new ValidationResult { IsValid = true };

            string name = account.GetAttributeValue<string>("name");
            if (string.IsNullOrWhiteSpace(name))
            {
                result.IsValid = false;
                result.Errors.Add("Account name is required");
            }

            if (name != null && name.Length > 160)
            {
                result.IsValid = false;
                result.Errors.Add("Account name exceeds maximum length");
            }

            _tracing.Trace($"Validation result: {result.IsValid}");
            return result;
        }
    }

    // Generic Repository
    public class DynamicsRepository<T> : IRepository<T> where T : Entity
    {
        private readonly IOrganizationService _service;
        private readonly string _entityLogicalName;

        public DynamicsRepository(IOrganizationService service, string entityLogicalName)
        {
            _service = service;
            _entityLogicalName = entityLogicalName;
        }

        public T GetById(Guid id)
        {
            return (T)_service.Retrieve(_entityLogicalName, id, new ColumnSet(true));
        }

        public List<T> GetAll()
        {
            QueryExpression query = new QueryExpression(_entityLogicalName)
            {
                ColumnSet = new ColumnSet(true)
            };

            return _service.RetrieveMultiple(query).Entities.Cast<T>().ToList();
        }

        public void Save(T entity)
        {
            if (entity.Id == Guid.Empty)
            {
                _service.Create(entity);
            }
            else
            {
                _service.Update(entity);
            }
        }

        public void Delete(Guid id)
        {
            _service.Delete(_entityLogicalName, id);
        }
    }

    // Account Business Logic
    public class AccountBusinessLogic : IBusinessLogic<Entity>
    {
        private readonly IOrganizationService _service;
        private readonly ITracingService _tracing;
        private readonly IEntityValidator<Entity> _validator;
        private readonly IRepository<Entity> _repository;
        private readonly INotificationService _notification;

        public AccountBusinessLogic(
            IOrganizationService service,
            ITracingService tracing,
            IEntityValidator<Entity> validator,
            IRepository<Entity> repository,
            INotificationService notification)
        {
            _service = service;
            _tracing = tracing;
            _validator = validator;
            _repository = repository;
            _notification = notification;
        }

        public void ProcessEntity(Entity account)
        {
            try
            {
                _tracing.Trace("Processing account");

                // Validate
                ValidationResult validation = _validator.Validate(account);
                if (!validation.IsValid)
                {
                    string errors = string.Join(", ", validation.Errors);
                    throw new InvalidPluginExecutionException($"Validation failed: {errors}");
                }

                // Set defaults
                if (!account.Contains("accountcategorycode"))
                {
                    account["accountcategorycode"] = new OptionSetValue(1);
                }

                // Save
                _repository.Save(account);

                // Notify
                _notification.NotifySuccess($"Account {account.GetAttributeValue<string>("name")} processed");

                _tracing.Trace("Account processed successfully");
            }
            catch (Exception ex)
            {
                _tracing.Trace($"Error processing account: {ex.Message}");
                _notification.NotifyError("Account processing failed", ex);
                throw;
            }
        }
    }

    // Notification Service
    public class EmailNotificationService : INotificationService
    {
        private readonly IOrganizationService _service;

        public EmailNotificationService(IOrganizationService service)
        {
            _service = service;
        }

        public void NotifySuccess(string message)
        {
            // Send success email
            SendEmail("admin@contoso.com", "Success", message);
        }

        public void NotifyError(string message, Exception ex)
        {
            // Send error email
            SendEmail("admin@contoso.com", "Error", $"{message}: {ex.Message}");
        }

        private void SendEmail(string to, string subject, string body)
        {
            Entity email = new Entity("email");
            email["to"] = to;
            email["subject"] = subject;
            email["description"] = body;
            _service.Create(email);
        }
    }

    // ============================================================================
    // WARSTWA 3: PLUGIN Z DI
    // ============================================================================

    public class AccountCreatePlugin : IPlugin
    {
        // Optional dependencies (dla testowania)
        private readonly IEntityValidator<Entity> _validator;
        private readonly IRepository<Entity> _repository;
        private readonly IBusinessLogic<Entity> _businessLogic;
        private readonly INotificationService _notification;

        // Konstruktor bezparametrowy (Dynamics requirement)
        public AccountCreatePlugin() : this(null, null, null, null)
        {
        }

        // Konstruktor z DI (testing)
        public AccountCreatePlugin(
            IEntityValidator<Entity> validator,
            IRepository<Entity> repository,
            IBusinessLogic<Entity> businessLogic,
            INotificationService notification)
        {
            _validator = validator;
            _repository = repository;
            _businessLogic = businessLogic;
            _notification = notification;
        }

        public void Execute(IServiceProvider serviceProvider)
        {
            // Get Dynamics services
            IPluginExecutionContext context = (IPluginExecutionContext)serviceProvider.GetService(typeof(IPluginExecutionContext));
            IOrganizationServiceFactory factory = (IOrganizationServiceFactory)serviceProvider.GetService(typeof(IOrganizationServiceFactory));
            IOrganizationService service = factory.CreateOrganizationService(context.UserId);
            ITracingService tracing = (ITracingService)serviceProvider.GetService(typeof(ITracingService));

            try
            {
                Entity target = GetTarget(context);
                if (target == null || target.LogicalName != "account")
                {
                    return;
                }

                // Create dependencies (production) or use injected (testing)
                IEntityValidator<Entity> validator = _validator ?? new AccountValidator(tracing);
                IRepository<Entity> repository = _repository ?? new DynamicsRepository<Entity>(service, "account");
                INotificationService notification = _notification ?? new EmailNotificationService(service);
                IBusinessLogic<Entity> businessLogic = _businessLogic ?? new AccountBusinessLogic(
                    service, tracing, validator, repository, notification);

                // Execute business logic
                businessLogic.ProcessEntity(target);
            }
            catch (Exception ex)
            {
                tracing.Trace($"Plugin error: {ex.Message}");
                throw new InvalidPluginExecutionException("Error in AccountCreatePlugin", ex);
            }
        }

        private Entity GetTarget(IPluginExecutionContext context)
        {
            if (context.InputParameters.Contains("Target") && context.InputParameters["Target"] is Entity)
            {
                return (Entity)context.InputParameters["Target"];
            }
            return null;
        }
    }

    // ============================================================================
    // SUPPORT CLASSES
    // ============================================================================

    public class ValidationResult
    {
        public bool IsValid { get; set; }
        public List<string> Errors { get; set; } = new List<string>();
    }
}
```

> 💡 **TIP**: Ten wzorzec (interfaces + constructor injection + optional dependencies) pozwala na:
> - Unit testing z mock'ami
> - Łatwą wymianę implementacji
> - Separację odpowiedzialności (SRP)
> - Maintainability i rozszerzalność

---

## Ćwiczenia praktyczne

### Ćwiczenie 1: Podstawy C# (Junior)

**Zadanie:** Stwórz klasę `ContactManager` która:
1. Przechowuje listę kontaktów (Entity)
2. Dodaje nowy kontakt z walidacją (firstname lub lastname wymagane)
3. Znajduje kontakty po nazwisku (LINQ)
4. Zwraca statystyki (ile kontaktów, ile active)

```csharp
// Twoje rozwiązanie tutaj
public class ContactManager
{
    // TODO: Implement
}
```

**Rozwiązanie:**
<details>
<summary>Kliknij aby zobaczyć rozwiązanie</summary>

```csharp
using Microsoft.Xrm.Sdk;
using System;
using System.Collections.Generic;
using System.Linq;

public class ContactManager
{
    private List<Entity> _contacts;

    public ContactManager()
    {
        _contacts = new List<Entity>();
    }

    public void AddContact(Entity contact)
    {
        // Walidacja
        string firstName = contact.GetAttributeValue<string>("firstname");
        string lastName = contact.GetAttributeValue<string>("lastname");

        if (string.IsNullOrWhiteSpace(firstName) && string.IsNullOrWhiteSpace(lastName))
        {
            throw new ArgumentException("Contact must have either first name or last name");
        }

        _contacts.Add(contact);
    }

    public List<Entity> FindByLastName(string lastName)
    {
        return _contacts
            .Where(c => c.GetAttributeValue<string>("lastname")?.Equals(lastName, StringComparison.OrdinalIgnoreCase) == true)
            .ToList();
    }

    public ContactStatistics GetStatistics()
    {
        return new ContactStatistics
        {
            TotalCount = _contacts.Count,
            ActiveCount = _contacts.Count(c => c.GetAttributeValue<OptionSetValue>("statecode")?.Value == 0)
        };
    }
}

public class ContactStatistics
{
    public int TotalCount { get; set; }
    public int ActiveCount { get; set; }
}
```
</details>

### Ćwiczenie 2: LINQ i kolekcje (Mid)

**Zadanie:** Mając listę accounts, napisz zapytania LINQ które:
1. Zwracają top 10 accounts po revenue
2. Grupują accounts po kategorii i liczą je
3. Zwracają accounts utworzone w tym miesiącu
4. Obliczają średni revenue dla każdej kategorii

### Ćwiczenie 3: Async/Await (Mid)

**Zadanie:** Stwórz metodę `EnrichMultipleAccountsAsync` która:
1. Przyjmuje listę account IDs
2. Dla każdego account wywołuje external API (symuluj Task.Delay)
3. Przetwarza accounts w batchach po 5 równolegle
4. Zwraca listę enriched accounts
5. Obsługuje błędy gracefully

### Ćwiczenie 4: Dependency Injection (Senior)

**Zadanie:** Zrefaktoruj poniższy plugin używając DI:

```csharp
public class BadPlugin : IPlugin
{
    public void Execute(IServiceProvider serviceProvider)
    {
        var context = (IPluginExecutionContext)serviceProvider.GetService(typeof(IPluginExecutionContext));
        var factory = (IOrganizationServiceFactory)serviceProvider.GetService(typeof(IOrganizationServiceFactory));
        var service = factory.CreateOrganizationService(context.UserId);

        Entity target = (Entity)context.InputParameters["Target"];

        // Validation hardcoded
        if (string.IsNullOrWhiteSpace(target.GetAttributeValue<string>("name")))
        {
            throw new InvalidPluginExecutionException("Name required");
        }

        // Business logic hardcoded
        target["accountcategorycode"] = new OptionSetValue(1);

        // Direct service call
        service.Update(target);
    }
}
```

Stwórz:
- `IAccountValidator` interface i implementację
- `IAccountBusinessLogic` interface i implementację
- Zrefaktorowany plugin z constructor injection

### Ćwiczenie 5: OOP Design (Senior)

**Zadanie:** Zaprojektuj system walidacji dla różnych typów encji:
1. Stwórz abstract `BaseValidator` z template method pattern
2. Implementuj `AccountValidator`, `ContactValidator`, `OpportunityValidator`
3. Każdy validator powinien mieć swoją specyficzną logikę
4. Użyj polimorfizmu aby walidować listę różnych encji

---

## Checklist przed przejściem do Rozdziału 2

Przed przejściem do następnego rozdziału upewnij się że:

- [ ] **Rozumiesz typy wartościowe vs referencyjne**
  - [ ] Potrafisz wyjaśnić różnicę
  - [ ] Wiesz kiedy używać struct vs class
  - [ ] Rozumiesz konsekwencje kopiowania przez wartość vs referencję

- [ ] **Opanowałeś nullable types**
  - [ ] Używasz `GetAttributeValue<T>()` konsekwentnie
  - [ ] Rozumiesz `?.` i `??` operatory
  - [ ] Potrafisz bezpiecznie obsłużyć null values

- [ ] **Znasz główne kolekcje**
  - [ ] Wiesz kiedy użyć List vs Dictionary vs HashSet
  - [ ] Rozumiesz performance implications każdej kolekcji
  - [ ] Potrafisz wybrać odpowiednią kolekcję do zadania

- [ ] **Rozumiesz OOP**
  - [ ] Potrafisz stworzyć klasy i interfejsy
  - [ ] Rozumiesz dziedziczenie i polimorfizm
  - [ ] Wiesz kiedy użyć interface vs abstract class
  - [ ] Potrafisz zastosować enkapsulację

- [ ] **Opanowałeś LINQ**
  - [ ] Potrafisz używać Where, Select, GroupBy, Join
  - [ ] Rozumiesz deferred vs immediate execution
  - [ ] Unikasz common anti-patterns
  - [ ] Potrafisz zoptymalizować LINQ queries

- [ ] **Rozumiesz async/await**
  - [ ] Wiesz kiedy używać async/await
  - [ ] Rozumiesz Task i Task<T>
  - [ ] Potrafisz obsłużyć błędy w async code
  - [ ] Unikasz async anti-patterns (.Result, .Wait())

- [ ] **Znasz Dependency Injection**
  - [ ] Rozumiesz constructor injection
  - [ ] Wiesz czym różnią się Singleton, Scoped, Transient
  - [ ] Potrafisz zaprojektować kod testable z DI
  - [ ] Rozumiesz IoC containers

- [ ] **Praktyka**
  - [ ] Ukończyłeś wszystkie ćwiczenia praktyczne
  - [ ] Eksperymentowałeś z kodem samodzielnie
  - [ ] Potrafisz napisać prosty plugin z DI
  - [ ] Rozumiesz przykłady kodu z tego rozdziału

---

## Podsumowanie rozdziału

W tym rozdziale poznałeś fundamenty języka C# w kontekście Power Platform:

✅ **Podstawy języka** - typy danych, nullable types, kolekcje
✅ **OOP** - klasy, interfejsy, dziedziczenie, polimorfizm, enkapsulacja
✅ **LINQ** - filtrowanie, projekcja, grupowanie, łączenie kolekcji
✅ **Async/Await** - asynchroniczne programowanie, Task, error handling
✅ **Dependency Injection** - IoC containers, constructor injection, testowalność

### Kluczowe wnioski:

> 💡 **Zawsze waliduj input** - użyj `GetAttributeValue<T>()` i sprawdzaj null

> 💡 **LINQ to potęga** - ale używaj go mądrze (unikaj multiple iterations)

> 💡 **Async dla I/O** - używaj async/await dla operacji I/O-bound

> 💡 **DI dla testowalności** - projektuj kod z myślą o testach

### Co dalej?

W **Rozdziale 2** poznasz **TypeScript/JavaScript dla Power Platform** - język client-side dla form scripts, web resources i Power Apps Code Apps.

---


# Rozdział 2: TypeScript/JavaScript dla Power Platform

## Wprowadzenie

JavaScript i TypeScript są fundamentalnymi językami dla rozwoju client-side w ekosystemie Power Platform. Używane są do:
- **Form scripts** - customizacja formularzy w Model-Driven Apps  
- **Web Resources** - custom HTML/CSS/JS zasoby
- **Power Apps Code Apps** - pełne aplikacje React + TypeScript
- **Custom Pages** - rozszerzanie Canvas Apps
- **Power Automate** - custom actions i connectors

### Czego się nauczysz?

W tym rozdziale poznasz:
- TypeScript jako nadzbiór JavaScript z silnym typowaniem
- Nowoczesne ES6+ features używane w Power Platform
- Asynchroniczne programowanie z Promises i async/await
- Manipulację DOM dla form scripts
- Interfaces i type safety dla Dynamics entities

### Dlaczego TypeScript w Power Platform?

TypeScript oferuje znaczące korzyści nad czystym JavaScript:
- **Type Safety** - błędy wyłapane podczas kompilacji, nie w runtime
- **IntelliSense** - lepsze autocomplete w VS Code
- **Refactoring** - bezpieczniejsze zmiany w kodzie
- **Dokumentacja** - typy służą jako dokumentacja
- **Ekosystem** - pełne wsparcie dla React, modern frameworks

> 💡 **TIP**: Microsoft oficjalnie rekomenduje TypeScript dla Power Apps Code Apps i wszystkich nowych projektów JavaScript.

---

## 2.1 Podstawy TypeScript

### TypeScript vs JavaScript

TypeScript to "superset" JavaScript - każdy poprawny kod JavaScript jest poprawnym kodem TypeScript, ale nie na odwrót.

[Treść rozdziału 2 będzie kontynuowana w następnym commicie...]

---


## 2.3 Promises i Async/Await

Asynchroniczne programowanie jest fundamentem współczesnych aplikacji webowych. W Power Platform używamy promises i async/await do:
- Wywołań Web API (fetch)
- Operacji na bazie danych (Dataverse)
- External API calls
- File operations

### Promises - podstawy

Promise reprezentuje wartość która może być dostępna teraz, w przyszłości, lub nigdy.

```typescript
// Tworzenie Promise
const myPromise = new Promise<string>((resolve, reject) => {
    // Asynchroniczna operacja
    setTimeout(() => {
        const success = true;
        
        if (success) {
            resolve("Operation successful!");
        } else {
            reject(new Error("Operation failed"));
        }
    }, 1000);
});

// Użycie Promise z then/catch
myPromise
    .then(result => {
        console.log(result); // "Operation successful!"
    })
    .catch(error => {
        console.error(error);
    })
    .finally(() => {
        console.log("Operation completed");
    });

// Promise states
// - Pending: initial state
// - Fulfilled: operation completed successfully  
// - Rejected: operation failed

// Promise chaining
fetch("/api/data/v9.2/accounts")
    .then(response => response.json())
    .then(data => {
        console.log("Accounts:", data.value);
        return data.value.length;
    })
    .then(count => {
        console.log(`Found ${count} accounts`);
    })
    .catch(error => {
        console.error("Error:", error);
    });
```

### Async/Await syntax

Async/await to syntactic sugar nad Promises - czytelniejszy i łatwiejszy w maintainability.

```typescript
// Function returning Promise (old way)
function fetchAccountsOld(): Promise<any[]> {
    return fetch("/api/data/v9.2/accounts")
        .then(response => response.json())
        .then(data => data.value);
}

// Async function (modern way)
async function fetchAccounts(): Promise<any[]> {
    const response = await fetch("/api/data/v9.2/accounts");
    const data = await response.json();
    return data.value;
}

// Error handling with try/catch
async function fetchAccountsSafe(): Promise<any[]> {
    try {
        const response = await fetch("/api/data/v9.2/accounts");
        
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        const data = await response.json();
        return data.value;
    } catch (error) {
        console.error("Failed to fetch accounts:", error);
        return []; // Return empty array on error
    }
}

// Sequential async operations
async function createAccountWithContact(
    accountName: string,
    contactName: string
): Promise<void> {
    // First create account
    const accountResponse = await fetch("/api/data/v9.2/accounts", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ name: accountName })
    });
    
    const accountId = accountResponse.headers.get("OData-EntityId");
    
    // Then create contact linked to account
    await fetch("/api/data/v9.2/contacts", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
            firstname: contactName,
            "parentcustomerid_account@odata.bind": accountId
        })
    });
}

// Parallel async operations with Promise.all
async function fetchMultipleEntities(): Promise<any> {
    const [accounts, contacts, opportunities] = await Promise.all([
        fetch("/api/data/v9.2/accounts").then(r => r.json()),
        fetch("/api/data/v9.2/contacts").then(r => r.json()),
        fetch("/api/data/v9.2/opportunities").then(r => r.json())
    ]);
    
    return {
        accounts: accounts.value,
        contacts: contacts.value,
        opportunities: opportunities.value
    };
}

// Promise.race - first to complete wins
async function fetchWithTimeout(
    url: string,
    timeoutMs: number
): Promise<Response> {
    const fetchPromise = fetch(url);
    const timeoutPromise = new Promise<never>((_, reject) => {
        setTimeout(() => reject(new Error("Request timeout")), timeoutMs);
    });
    
    return Promise.race([fetchPromise, timeoutPromise]);
}
```

### Praktyczne przykłady dla Dynamics 365

```typescript
// ============================================================================
// WEB API OPERATIONS
// ============================================================================

class DynamicsWebAPI {
    private readonly baseUrl = "/api/data/v9.2";
    private readonly headers = {
        "OData-MaxVersion": "4.0",
        "OData-Version": "4.0",
        "Content-Type": "application/json"
    };

    // Create entity
    async create(entitySetName: string, entity: any): Promise<string> {
        const response = await fetch(`${this.baseUrl}/${entitySetName}`, {
            method: "POST",
            headers: this.headers,
            body: JSON.stringify(entity)
        });

        if (!response.ok) {
            const error = await response.json();
            throw new Error(error.error.message);
        }

        // Extract ID from response header
        const entityUrl = response.headers.get("OData-EntityId");
        const id = entityUrl?.match(/\(([^)]+)\)/)?.[1];
        
        if (!id) {
            throw new Error("Failed to extract entity ID");
        }

        return id;
    }

    // Retrieve entity
    async retrieve(
        entitySetName: string,
        id: string,
        select?: string[]
    ): Promise<any> {
        let url = `${this.baseUrl}/${entitySetName}(${id})`;
        
        if (select && select.length > 0) {
            url += `?$select=${select.join(",")}`;
        }

        const response = await fetch(url, {
            method: "GET",
            headers: this.headers
        });

        if (!response.ok) {
            throw new Error(`Failed to retrieve entity: ${response.statusText}`);
        }

        return response.json();
    }

    // Update entity
    async update(
        entitySetName: string,
        id: string,
        entity: any
    ): Promise<void> {
        const response = await fetch(`${this.baseUrl}/${entitySetName}(${id})`, {
            method: "PATCH",
            headers: this.headers,
            body: JSON.stringify(entity)
        });

        if (!response.ok) {
            const error = await response.json();
            throw new Error(error.error.message);
        }
    }

    // Delete entity
    async delete(entitySetName: string, id: string): Promise<void> {
        const response = await fetch(`${this.baseUrl}/${entitySetName}(${id})`, {
            method: "DELETE",
            headers: this.headers
        });

        if (!response.ok) {
            throw new Error(`Failed to delete entity: ${response.statusText}`);
        }
    }

    // Retrieve multiple with query
    async retrieveMultiple(
        entitySetName: string,
        query?: {
            select?: string[];
            filter?: string;
            orderby?: string;
            top?: number;
        }
    ): Promise<any[]> {
        const params: string[] = [];

        if (query?.select) {
            params.push(`$select=${query.select.join(",")}`);
        }

        if (query?.filter) {
            params.push(`$filter=${query.filter}`);
        }

        if (query?.orderby) {
            params.push(`$orderby=${query.orderby}`);
        }

        if (query?.top) {
            params.push(`$top=${query.top}`);
        }

        const queryString = params.length > 0 ? `?${params.join("&")}` : "";
        const url = `${this.baseUrl}/${entitySetName}${queryString}`;

        const response = await fetch(url, {
            method: "GET",
            headers: this.headers
        });

        if (!response.ok) {
            throw new Error(`Failed to retrieve entities: ${response.statusText}`);
        }

        const data = await response.json();
        return data.value;
    }
}

// Usage example
const api = new DynamicsWebAPI();

async function exampleUsage(): Promise<void> {
    try {
        // Create account
        const accountId = await api.create("accounts", {
            name: "Contoso Ltd",
            revenue: 1000000,
            numberofemployees: 250
        });

        console.log(`Account created: ${accountId}`);

        // Retrieve account
        const account = await api.retrieve("accounts", accountId, [
            "name",
            "revenue",
            "numberofemployees"
        ]);

        console.log("Account data:", account);

        // Update account
        await api.update("accounts", accountId, {
            revenue: 2000000
        });

        console.log("Account updated");

        // Query accounts
        const highRevenueAccounts = await api.retrieveMultiple("accounts", {
            filter: "revenue gt 1000000",
            select: ["name", "revenue"],
            orderby: "revenue desc",
            top: 10
        });

        console.log("High revenue accounts:", highRevenueAccounts);

    } catch (error) {
        console.error("Operation failed:", error);
    }
}

// ============================================================================
// FORM SCRIPT WITH ASYNC OPERATIONS
// ============================================================================

class AccountForm {
    private formContext: any;

    constructor(executionContext: any) {
        this.formContext = executionContext.getFormContext();
    }

    async onLoad(): Promise<void> {
        try {
            const accountId = this.formContext.data.entity.getId();
            
            if (accountId) {
                // Load related contacts in parallel
                const [contacts, opportunities] = await Promise.all([
                    this.loadRelatedContacts(accountId),
                    this.loadRelatedOpportunities(accountId)
                ]);

                this.displayRelatedData(contacts, opportunities);
            }

            // Setup change handlers
            this.setupChangeHandlers();

        } catch (error) {
            console.error("Error loading form:", error);
            this.showNotification("Error loading form data", "ERROR");
        }
    }

    private async loadRelatedContacts(accountId: string): Promise<any[]> {
        const api = new DynamicsWebAPI();
        return api.retrieveMultiple("contacts", {
            filter: `_parentcustomerid_value eq ${accountId}`,
            select: ["fullname", "emailaddress1", "telephone1"],
            orderby: "fullname asc"
        });
    }

    private async loadRelatedOpportunities(accountId: string): Promise<any[]> {
        const api = new DynamicsWebAPI();
        return api.retrieveMultiple("opportunities", {
            filter: `_customerid_value eq ${accountId}`,
            select: ["name", "estimatedvalue", "closeprobability"],
            orderby: "estimatedvalue desc"
        });
    }

    private displayRelatedData(contacts: any[], opportunities: any[]): void {
        // Update UI with related data
        const contactsControl = this.formContext.getControl("contacts_subgrid");
        const oppsControl = this.formContext.getControl("opportunities_subgrid");

        if (contactsControl) {
            contactsControl.refresh();
        }

        if (oppsControl) {
            oppsControl.refresh();
        }

        // Show summary notification
        this.showNotification(
            `Loaded ${contacts.length} contacts and ${opportunities.length} opportunities`,
            "INFO"
        );
    }

    private setupChangeHandlers(): void {
        const revenueAttr = this.formContext.getAttribute("revenue");
        
        if (revenueAttr) {
            revenueAttr.addOnChange(async () => {
                await this.onRevenueChange();
            });
        }
    }

    private async onRevenueChange(): Promise<void> {
        const revenue = this.formContext.getAttribute("revenue")?.getValue();
        
        if (revenue > 1000000) {
            // Call external API to verify large revenue
            try {
                const isValid = await this.verifyLargeRevenue(revenue);
                
                if (!isValid) {
                    this.showNotification(
                        "Large revenue amount requires additional verification",
                        "WARNING"
                    );
                }
            } catch (error) {
                console.error("Revenue verification failed:", error);
            }
        }
    }

    private async verifyLargeRevenue(amount: number): Promise<boolean> {
        // Simulate external API call
        await new Promise(resolve => setTimeout(resolve, 500));
        return true;
    }

    private showNotification(message: string, level: string): void {
        this.formContext.ui.setFormNotification(
            message,
            level,
            `notification_${Date.now()}`
        );
    }
}

// Register handlers
function onFormLoad(executionContext: any): void {
    const form = new AccountForm(executionContext);
    form.onLoad();
}
```

### Error handling patterns

```typescript
// ============================================================================
// RETRY PATTERN
// ============================================================================

async function retryOperation<T>(
    operation: () => Promise<T>,
    maxRetries: number = 3,
    delayMs: number = 1000
): Promise<T> {
    let lastError: Error;

    for (let attempt = 1; attempt <= maxRetries; attempt++) {
        try {
            return await operation();
        } catch (error) {
            lastError = error as Error;
            console.warn(`Attempt ${attempt} failed:`, error);

            if (attempt < maxRetries) {
                // Exponential backoff
                const delay = delayMs * Math.pow(2, attempt - 1);
                await new Promise(resolve => setTimeout(resolve, delay));
            }
        }
    }

    throw new Error(`Operation failed after ${maxRetries} attempts: ${lastError.message}`);
}

// Usage
async function fetchWithRetry(): Promise<any> {
    return retryOperation(
        () => fetch("/api/data/v9.2/accounts").then(r => r.json()),
        3,
        1000
    );
}

// ============================================================================
// TIMEOUT PATTERN
// ============================================================================

async function withTimeout<T>(
    promise: Promise<T>,
    timeoutMs: number
): Promise<T> {
    const timeout = new Promise<never>((_, reject) => {
        setTimeout(() => {
            reject(new Error(`Operation timed out after ${timeoutMs}ms`));
        }, timeoutMs);
    });

    return Promise.race([promise, timeout]);
}

// Usage
async function fetchWithTimeout(): Promise<any> {
    const fetchPromise = fetch("/api/data/v9.2/accounts").then(r => r.json());
    return withTimeout(fetchPromise, 5000); // 5 second timeout
}

// ============================================================================
// CIRCUIT BREAKER PATTERN
// ============================================================================

class CircuitBreaker {
    private failures: number = 0;
    private lastFailureTime: number = 0;
    private state: "CLOSED" | "OPEN" | "HALF_OPEN" = "CLOSED";

    constructor(
        private threshold: number = 5,
        private timeout: number = 60000
    ) {}

    async execute<T>(operation: () => Promise<T>): Promise<T> {
        if (this.state === "OPEN") {
            if (Date.now() - this.lastFailureTime > this.timeout) {
                this.state = "HALF_OPEN";
            } else {
                throw new Error("Circuit breaker is OPEN");
            }
        }

        try {
            const result = await operation();
            this.onSuccess();
            return result;
        } catch (error) {
            this.onFailure();
            throw error;
        }
    }

    private onSuccess(): void {
        this.failures = 0;
        this.state = "CLOSED";
    }

    private onFailure(): void {
        this.failures++;
        this.lastFailureTime = Date.now();

        if (this.failures >= this.threshold) {
            this.state = "OPEN";
        }
    }
}

// Usage
const breaker = new CircuitBreaker(5, 60000);

async function fetchWithCircuitBreaker(): Promise<any> {
    return breaker.execute(() =>
        fetch("/api/data/v9.2/accounts").then(r => r.json())
    );
}
```

---

## 2.4 DOM Manipulation

W Dynamics 365 używamy DOM manipulation głównie w web resources i custom pages. Znajomość DOM API jest kluczowa dla customizacji interfejsu.

### QuerySelector i event listeners

```typescript
// ============================================================================
// QUERY SELECTORS
// ============================================================================

// getElementById - najszybsze, ale wymaga unique ID
const nameField = document.getElementById("account_name");

// querySelector - pierwszy matching element
const firstButton = document.querySelector("button.save-btn");
const firstInput = document.querySelector('input[type="text"]');

// querySelectorAll - wszystkie matching elements (NodeList)
const allButtons = document.querySelectorAll("button");
const allInputs = document.querySelectorAll('input[type="text"]');

// Iteracja przez NodeList
allButtons.forEach(button => {
    console.log(button.textContent);
});

// Convert NodeList to Array dla advanced operations
const buttonsArray = Array.from(allButtons);
const activeButtons = buttonsArray.filter(btn => !btn.disabled);

// ============================================================================
// EVENT LISTENERS
// ============================================================================

// Basic event listener
const saveButton = document.getElementById("saveButton");
saveButton?.addEventListener("click", (event) => {
    console.log("Save clicked");
    event.preventDefault(); // Prevent default action
});

// Event listener with options
saveButton?.addEventListener("click", handleSave, {
    once: true,      // Remove after first call
    passive: true,   // Never calls preventDefault
    capture: false   // Bubbling phase
});

function handleSave(event: Event): void {
    const target = event.target as HTMLButtonElement;
    console.log("Button clicked:", target.textContent);
}

// Remove event listener
saveButton?.removeEventListener("click", handleSave);

// Multiple event types
const input = document.getElementById("nameInput") as HTMLInputElement;

input?.addEventListener("focus", () => {
    console.log("Input focused");
});

input?.addEventListener("blur", () => {
    console.log("Input blurred");
});

input?.addEventListener("input", (event) => {
    const target = event.target as HTMLInputElement;
    console.log("Input value:", target.value);
});

input?.addEventListener("change", (event) => {
    const target = event.target as HTMLInputElement;
    console.log("Input changed:", target.value);
});

// ============================================================================
// EVENT DELEGATION
// ============================================================================

// Instead of adding listener to each button
const container = document.getElementById("buttonsContainer");

container?.addEventListener("click", (event) => {
    const target = event.target as HTMLElement;
    
    // Check if clicked element is a button
    if (target.tagName === "BUTTON") {
        console.log("Button clicked:", target.textContent);
    }
});

// Practical example for dynamic lists
const accountList = document.getElementById("accountList");

accountList?.addEventListener("click", (event) => {
    const target = event.target as HTMLElement;
    
    // Find closest account item
    const accountItem = target.closest(".account-item");
    
    if (accountItem) {
        const accountId = accountItem.getAttribute("data-account-id");
        console.log("Account selected:", accountId);
    }
});
```

### Element creation i modification

```typescript
// ============================================================================
// CREATING ELEMENTS
// ============================================================================

// Create element
const div = document.createElement("div");
div.className = "account-card";
div.id = "account-123";

// Set attributes
div.setAttribute("data-account-id", "123");
div.setAttribute("data-category", "enterprise");

// Add text content
div.textContent = "Contoso Ltd";

// Add HTML content
div.innerHTML = `
    <h3>Contoso Ltd</h3>
    <p>Revenue: $1,000,000</p>
`;

// Create text node
const textNode = document.createTextNode("Hello, World!");

// Append to DOM
const container = document.getElementById("accountsContainer");
container?.appendChild(div);

// Insert before
const firstChild = container?.firstChild;
container?.insertBefore(div, firstChild);

// Remove element
div.remove();

// Or using parent
container?.removeChild(div);

// ============================================================================
// MODIFYING ELEMENTS
// ============================================================================

// Change text
const heading = document.getElementById("pageTitle");
if (heading) {
    heading.textContent = "Account Details";
    heading.innerHTML = "<strong>Account Details</strong>";
}

// Change attributes
const image = document.getElementById("logo") as HTMLImageElement;
if (image) {
    image.src = "/images/new-logo.png";
    image.alt = "Company Logo";
}

// Add/remove classes
const button = document.getElementById("saveBtn");
if (button) {
    button.classList.add("primary");
    button.classList.remove("secondary");
    button.classList.toggle("active");
    
    const hasClass = button.classList.contains("primary"); // true
}

// Modify styles
const card = document.getElementById("accountCard");
if (card) {
    card.style.backgroundColor = "#f0f0f0";
    card.style.padding = "20px";
    card.style.borderRadius = "8px";
    
    // Multiple styles
    Object.assign(card.style, {
        backgroundColor: "#f0f0f0",
        padding: "20px",
        borderRadius: "8px",
        boxShadow: "0 2px 4px rgba(0,0,0,0.1)"
    });
}

// Get computed style
const computedStyle = window.getComputedStyle(card!);
const bgColor = computedStyle.backgroundColor;

// ============================================================================
// PRACTICAL DYNAMICS EXAMPLES
// ============================================================================

// Create account card
function createAccountCard(account: {
    id: string;
    name: string;
    revenue: number;
    category: string;
}): HTMLElement {
    const card = document.createElement("div");
    card.className = "account-card";
    card.setAttribute("data-account-id", account.id);
    
    card.innerHTML = `
        <div class="card-header">
            <h3>${account.name}</h3>
            <span class="category-badge">${account.category}</span>
        </div>
        <div class="card-body">
            <p class="revenue">Revenue: $${account.revenue.toLocaleString()}</p>
        </div>
        <div class="card-footer">
            <button class="btn btn-view" data-action="view">View</button>
            <button class="btn btn-edit" data-action="edit">Edit</button>
        </div>
    `;
    
    return card;
}

// Render list of accounts
function renderAccounts(accounts: any[]): void {
    const container = document.getElementById("accountsContainer");
    
    if (!container) return;
    
    // Clear existing content
    container.innerHTML = "";
    
    // Create and append account cards
    accounts.forEach(account => {
        const card = createAccountCard(account);
        container.appendChild(card);
    });
    
    // Add event listeners
    container.addEventListener("click", handleAccountAction);
}

function handleAccountAction(event: Event): void {
    const target = event.target as HTMLElement;
    
    if (target.classList.contains("btn")) {
        const action = target.getAttribute("data-action");
        const card = target.closest(".account-card");
        const accountId = card?.getAttribute("data-account-id");
        
        console.log(`Action: ${action}, Account: ${accountId}`);
    }
}

// Dynamic form field
function createFormField(config: {
    label: string;
    name: string;
    type: string;
    required: boolean;
}): HTMLElement {
    const fieldContainer = document.createElement("div");
    fieldContainer.className = "form-field";
    
    const label = document.createElement("label");
    label.htmlFor = config.name;
    label.textContent = config.label;
    if (config.required) {
        label.innerHTML += ' <span class="required">*</span>';
    }
    
    const input = document.createElement("input");
    input.type = config.type;
    input.name = config.name;
    input.id = config.name;
    input.required = config.required;
    
    fieldContainer.appendChild(label);
    fieldContainer.appendChild(input);
    
    return fieldContainer;
}

// Show/hide loading spinner
function showLoading(show: boolean): void {
    let spinner = document.getElementById("loadingSpinner");
    
    if (show && !spinner) {
        spinner = document.createElement("div");
        spinner.id = "loadingSpinner";
        spinner.className = "spinner";
        spinner.innerHTML = '<div class="spinner-icon"></div>';
        document.body.appendChild(spinner);
    } else if (!show && spinner) {
        spinner.remove();
    }
}

// Update form notification
function showFormNotification(
    message: string,
    type: "success" | "error" | "warning" | "info"
): void {
    const notification = document.createElement("div");
    notification.className = `notification notification-${type}`;
    notification.textContent = message;
    
    const container = document.getElementById("notificationsContainer");
    container?.appendChild(notification);
    
    // Auto-remove after 5 seconds
    setTimeout(() => {
        notification.classList.add("fade-out");
        setTimeout(() => notification.remove(), 300);
    }, 5000);
}
```

### Event delegation patterns

```typescript
// ============================================================================
// ADVANCED EVENT DELEGATION
// ============================================================================

class DynamicList {
    private container: HTMLElement;
    private items: any[] = [];

    constructor(containerId: string) {
        const container = document.getElementById(containerId);
        if (!container) {
            throw new Error(`Container ${containerId} not found`);
        }
        this.container = container;
        this.setupEventListeners();
    }

    private setupEventListeners(): void {
        // Single event listener for all items
        this.container.addEventListener("click", this.handleClick.bind(this));
        this.container.addEventListener("change", this.handleChange.bind(this));
    }

    private handleClick(event: Event): void {
        const target = event.target as HTMLElement;
        
        // Handle delete button
        if (target.classList.contains("btn-delete")) {
            const itemId = this.getItemId(target);
            this.deleteItem(itemId);
        }
        
        // Handle edit button
        if (target.classList.contains("btn-edit")) {
            const itemId = this.getItemId(target);
            this.editItem(itemId);
        }
        
        // Handle checkbox
        if (target.tagName === "INPUT" && target.getAttribute("type") === "checkbox") {
            const itemId = this.getItemId(target);
            const checked = (target as HTMLInputElement).checked;
            this.toggleItem(itemId, checked);
        }
    }

    private handleChange(event: Event): void {
        const target = event.target as HTMLElement;
        
        if (target.tagName === "SELECT") {
            const itemId = this.getItemId(target);
            const value = (target as HTMLSelectElement).value;
            this.updateItemStatus(itemId, value);
        }
    }

    private getItemId(element: HTMLElement): string {
        const item = element.closest("[data-item-id]");
        return item?.getAttribute("data-item-id") ?? "";
    }

    private deleteItem(id: string): void {
        console.log("Delete item:", id);
        // Implementation
    }

    private editItem(id: string): void {
        console.log("Edit item:", id);
        // Implementation
    }

    private toggleItem(id: string, checked: boolean): void {
        console.log("Toggle item:", id, checked);
        // Implementation
    }

    private updateItemStatus(id: string, status: string): void {
        console.log("Update status:", id, status);
        // Implementation
    }

    render(items: any[]): void {
        this.items = items;
        this.container.innerHTML = items.map(item => this.renderItem(item)).join("");
    }

    private renderItem(item: any): string {
        return `
            <div class="list-item" data-item-id="${item.id}">
                <input type="checkbox" ${item.completed ? "checked" : ""} />
                <span class="item-name">${item.name}</span>
                <select class="item-status">
                    <option value="pending" ${item.status === "pending" ? "selected" : ""}>Pending</option>
                    <option value="active" ${item.status === "active" ? "selected" : ""}>Active</option>
                    <option value="completed" ${item.status === "completed" ? "selected" : ""}>Completed</option>
                </select>
                <button class="btn btn-edit">Edit</button>
                <button class="btn btn-delete">Delete</button>
            </div>
        `;
    }
}

// Usage
const list = new DynamicList("accountsList");
list.render([
    { id: "1", name: "Contoso", status: "active", completed: false },
    { id: "2", name: "Fabrikam", status: "pending", completed: false }
]);
```

---

## 2.5 Interfaces i Type Safety

Interfaces w TypeScript pozwalają definiować strukturę danych w sposób który zapewnia type safety i lepsze developer experience.

### Definiowanie interfaces dla Dynamics entities

```typescript
// ============================================================================
// DYNAMICS ENTITY INTERFACES
// ============================================================================

// Base entity interface
interface BaseEntity {
    "@odata.etag"?: string;
    createdon?: string;
    modifiedon?: string;
    statecode?: number;
    statuscode?: number;
}

// Entity Reference
interface EntityReference {
    "@odata.id"?: string;
    "@odata.type"?: string;
    id: string;
    logicalName: string;
    name?: string;
}

// OptionSet Value
interface OptionSetValue {
    value: number;
    label?: string;
}

// Money
interface Money {
    value: number;
}

// Account entity
interface Account extends BaseEntity {
    accountid: string;
    name: string;
    accountnumber?: string;
    revenue?: number;
    numberofemployees?: number;
    telephone1?: string;
    emailaddress1?: string;
    websiteurl?: string;
    description?: string;
    
    // Lookup fields
    primarycontactid?: EntityReference;
    ownerid?: EntityReference;
    
    // OptionSet fields
    accountcategorycode?: number;
    accountratingcode?: number;
    customertypecode?: number;
    
    // Formatted values (read-only)
    "accountcategorycode@OData.Community.Display.V1.FormattedValue"?: string;
    "createdon@OData.Community.Display.V1.FormattedValue"?: string;
}

// Contact entity
interface Contact extends BaseEntity {
    contactid: string;
    firstname: string;
    lastname: string;
    fullname?: string;
    emailaddress1?: string;
    telephone1?: string;
    mobilephone?: string;
    jobtitle?: string;
    
    // Lookups
    parentcustomerid?: EntityReference;
    ownerid?: EntityReference;
    
    // OptionSets
    preferredcontactmethodcode?: number;
    customertypecode?: number;
}

// Opportunity entity
interface Opportunity extends BaseEntity {
    opportunityid: string;
    name: string;
    estimatedvalue?: number;
    closeprobability?: number;
    estimatedclosedate?: string;
    description?: string;
    
    // Lookups
    customerid?: EntityReference;
    ownerid?: EntityReference;
    
    // OptionSets
    salesstagecode?: number;
    opportunityratingcode?: number;
}

// ============================================================================
// GENERIC ENTITY OPERATIONS
// ============================================================================

// CRUD operations interface
interface ICrudOperations<T extends BaseEntity> {
    create(entity: Omit<T, keyof BaseEntity>): Promise<string>;
    retrieve(id: string, select?: (keyof T)[]): Promise<T>;
    update(id: string, entity: Partial<T>): Promise<void>;
    delete(id: string): Promise<void>;
    retrieveMultiple(query: QueryOptions<T>): Promise<T[]>;
}

// Query options
interface QueryOptions<T> {
    select?: (keyof T)[];
    filter?: string;
    orderby?: { field: keyof T; direction: "asc" | "desc" }[];
    top?: number;
    expand?: ExpandOption<T>[];
}

interface ExpandOption<T> {
    navigationProperty: string;
    select?: string[];
}

// ============================================================================
// TYPE-SAFE REPOSITORY
// ============================================================================

class EntityRepository<T extends BaseEntity> implements ICrudOperations<T> {
    constructor(
        private entitySetName: string,
        private entityIdField: keyof T
    ) {}

    async create(entity: Omit<T, keyof BaseEntity>): Promise<string> {
        const api = new DynamicsWebAPI();
        return api.create(this.entitySetName, entity);
    }

    async retrieve(id: string, select?: (keyof T)[]): Promise<T> {
        const api = new DynamicsWebAPI();
        const selectFields = select?.map(f => f.toString());
        return api.retrieve(this.entitySetName, id, selectFields);
    }

    async update(id: string, entity: Partial<T>): Promise<void> {
        const api = new DynamicsWebAPI();
        return api.update(this.entitySetName, id, entity);
    }

    async delete(id: string): Promise<void> {
        const api = new DynamicsWebAPI();
        return api.delete(this.entitySetName, id);
    }

    async retrieveMultiple(query: QueryOptions<T>): Promise<T[]> {
        const api = new DynamicsWebAPI();
        
        const apiQuery: any = {};
        
        if (query.select) {
            apiQuery.select = query.select.map(f => f.toString());
        }
        
        if (query.filter) {
            apiQuery.filter = query.filter;
        }
        
        if (query.orderby) {
            apiQuery.orderby = query.orderby
                .map(o => `${o.field.toString()} ${o.direction}`)
                .join(",");
        }
        
        if (query.top) {
            apiQuery.top = query.top;
        }
        
        return api.retrieveMultiple(this.entitySetName, apiQuery);
    }
}

// ============================================================================
// USAGE EXAMPLES
// ============================================================================

// Type-safe account repository
const accountRepo = new EntityRepository<Account>("accounts", "accountid");

async function workWithAccounts(): Promise<void> {
    // Create - TypeScript ensures we provide required fields
    const accountId = await accountRepo.create({
        name: "Contoso Ltd", // Required
        revenue: 1000000,
        numberofemployees: 250
    });

    // Retrieve - type-safe field selection
    const account = await accountRepo.retrieve(accountId, [
        "name",
        "revenue",
        "numberofemployees",
        "primarycontactid"
    ]);

    // TypeScript knows the structure
    console.log(account.name); // ✅ Type-safe
    console.log(account.revenue); // ✅ Type-safe
    // console.log(account.invalidField); // ❌ Compile error!

    // Update - Partial<T> allows updating subset of fields
    await accountRepo.update(accountId, {
        revenue: 2000000
    });

    // Query - type-safe filters and ordering
    const highRevenueAccounts = await accountRepo.retrieveMultiple({
        filter: "revenue gt 1000000",
        select: ["name", "revenue", "numberofemployees"],
        orderby: [{ field: "revenue", direction: "desc" }],
        top: 10
    });

    // Process results with full type safety
    for (const acc of highRevenueAccounts) {
        console.log(`${acc.name}: $${acc.revenue}`);
    }
}

// ============================================================================
// FORM CONTEXT TYPING
// ============================================================================

// Comprehensive form context interfaces
interface Xrm {
    Page: FormContext;
    Navigation: Navigation;
    Utility: Utility;
    WebApi: WebApi;
}

interface FormContext {
    data: FormData;
    ui: FormUI;
    getAttribute(attributeName: string): Attribute | null;
    getControl(controlName: string): Control | null;
}

interface FormData {
    entity: Entity;
    process: Process;
    save(saveOptions?: SaveOptions): Promise<void>;
    refresh(save?: boolean): Promise<void>;
}

interface Entity {
    getEntityName(): string;
    getId(): string;
    getIsDirty(): boolean;
    getPrimaryAttributeValue(): any;
    
    attributes: AttributeCollection;
    
    addOnSave(handler: () => void): void;
    removeOnSave(handler: () => void): void;
}

interface AttributeCollection {
    get(): Attribute[];
    get(attributeName: string): Attribute | null;
    get(index: number): Attribute | null;
    get(delegate: (attribute: Attribute, index: number) => boolean): Attribute[];
    
    forEach(delegate: (attribute: Attribute, index: number) => void): void;
    getLength(): number;
}

interface Attribute {
    getName(): string;
    getValue<T = any>(): T | null;
    setValue(value: any): void;
    
    getRequiredLevel(): "none" | "required" | "recommended";
    setRequiredLevel(level: "none" | "required" | "recommended"): void;
    
    getIsDirty(): boolean;
    
    addOnChange(handler: () => void): void;
    removeOnChange(handler: () => void): void;
    
    controls: ControlCollection;
}

interface ControlCollection {
    get(): Control[];
    get(controlName: string): Control | null;
    get(index: number): Control | null;
    forEach(delegate: (control: Control, index: number) => void): void;
    getLength(): number;
}

interface Control {
    getName(): string;
    getControlType(): string;
    
    getVisible(): boolean;
    setVisible(visible: boolean): void;
    
    getDisabled(): boolean;
    setDisabled(disabled: boolean): void;
    
    getLabel(): string;
    setLabel(label: string): void;
    
    getAttribute(): Attribute | null;
    
    setFocus(): void;
}

interface FormUI {
    controls: ControlCollection;
    tabs: TabCollection;
    
    setFormNotification(message: string, level: "INFO" | "WARNING" | "ERROR", uniqueId: string): boolean;
    clearFormNotification(uniqueId: string): boolean;
    
    getFormType(): 0 | 1 | 2 | 3 | 4 | 6; // Undefined, Create, Update, ReadOnly, Disabled, BulkEdit
    
    close(): void;
}

interface TabCollection {
    get(): Tab[];
    get(tabName: string): Tab | null;
    get(index: number): Tab | null;
    forEach(delegate: (tab: Tab, index: number) => void): void;
    getLength(): number;
}

interface Tab {
    getName(): string;
    getLabel(): string;
    setLabel(label: string): void;
    
    getVisible(): boolean;
    setVisible(visible: boolean): void;
    
    getDisplayState(): "expanded" | "collapsed";
    setDisplayState(state: "expanded" | "collapsed"): void;
    
    sections: SectionCollection;
}

interface SectionCollection {
    get(): Section[];
    get(sectionName: string): Section | null;
    get(index: number): Section | null;
    forEach(delegate: (section: Section, index: number) => void): void;
    getLength(): number;
}

interface Section {
    getName(): string;
    getLabel(): string;
    setLabel(label: string): void;
    
    getVisible(): boolean;
    setVisible(visible: boolean): void;
    
    controls: ControlCollection;
}

interface SaveOptions {
    saveMode: 1 | 2 | 47 | 58 | 59 | 70; // Save, SaveAndClose, AutoSave, SaveAsCompleted, SaveAndNew, Qualify
}

// ============================================================================
// TYPE-SAFE FORM SCRIPT
// ============================================================================

class TypeSafeAccountForm {
    private formContext: FormContext;

    constructor(executionContext: any) {
        this.formContext = executionContext.getFormContext();
    }

    onLoad(): void {
        this.setupFieldRequirements();
        this.setupFieldVisibility();
        this.setupChangeHandlers();
    }

    private setupFieldRequirements(): void {
        // Type-safe field access
        const nameAttr = this.formContext.getAttribute("name");
        const revenueAttr = this.formContext.getAttribute("revenue");
        
        nameAttr?.setRequiredLevel("required");
        revenueAttr?.setRequiredLevel("recommended");
    }

    private setupFieldVisibility(): void {
        const formType = this.formContext.ui.getFormType();
        
        // Show certain fields only on create
        if (formType === 1) { // Create
            this.formContext.getControl("accountnumber")?.setVisible(true);
        }
    }

    private setupChangeHandlers(): void {
        this.formContext.getAttribute("revenue")?.addOnChange(() => {
            this.onRevenueChange();
        });
    }

    private onRevenueChange(): void {
        const revenue = this.formContext.getAttribute("revenue")?.getValue<number>();
        
        if (revenue && revenue > 1000000) {
            this.formContext.ui.setFormNotification(
                "High revenue account requires approval",
                "WARNING",
                "revenue_warning"
            );
        } else {
            this.formContext.ui.clearFormNotification("revenue_warning");
        }
    }

    onSave(executionContext: any): void {
        const saveEvent = executionContext.getEventArgs();
        
        // Validate before save
        if (!this.validateForm()) {
            saveEvent.preventDefault();
        }
    }

    private validateForm(): boolean {
        const name = this.formContext.getAttribute("name")?.getValue<string>();
        
        if (!name || name.trim().length === 0) {
            this.formContext.ui.setFormNotification(
                "Account name is required",
                "ERROR",
                "name_validation"
            );
            return false;
        }
        
        return true;
    }
}

// Register handlers - global functions required by Dynamics
function onAccountFormLoad(executionContext: any): void {
    const form = new TypeSafeAccountForm(executionContext);
    form.onLoad();
}

function onAccountFormSave(executionContext: any): void {
    const form = new TypeSafeAccountForm(executionContext);
    form.onSave(executionContext);
}
```

---

[KONIEC ROZDZIAŁU 2 - CZĘŚĆ 1]

---

## Ćwiczenia praktyczne

### Ćwiczenie 1: TypeScript Basics (Junior)

**Zadanie:** Stwórz system typowania dla Dynamics entities

1. Zdefiniuj interfaces dla: Account, Contact, Opportunity
2. Dodaj EntityReference, OptionSetValue, Money types
3. Stwórz union type dla wszystkich entity types
4. Napisz type guard function `isAccount()`, `isContact()`

```typescript
// Twoje rozwiązanie tutaj
interface Account {
    // TODO: Define Account interface
}

interface Contact {
    // TODO: Define Contact interface
}

function isAccount(entity: any): entity is Account {
    // TODO: Implement type guard
}
```

**Rozwiązanie:**
<details>
<summary>Kliknij aby zobaczyć rozwiązanie</summary>

```typescript
interface EntityReference {
    id: string;
    logicalName: string;
    name?: string;
}

interface OptionSetValue {
    value: number;
    label?: string;
}

interface Money {
    value: number;
}

interface BaseEntity {
    id: string;
    logicalName: string;
}

interface Account extends BaseEntity {
    logicalName: "account";
    name: string;
    revenue?: Money;
    primarycontactid?: EntityReference;
}

interface Contact extends BaseEntity {
    logicalName: "contact";
    firstname: string;
    lastname: string;
    emailaddress1?: string;
}

interface Opportunity extends BaseEntity {
    logicalName: "opportunity";
    name: string;
    estimatedvalue?: Money;
    customerid?: EntityReference;
}

type DynamicsEntity = Account | Contact | Opportunity;

function isAccount(entity: DynamicsEntity): entity is Account {
    return entity.logicalName === "account";
}

function isContact(entity: DynamicsEntity): entity is Contact {
    return entity.logicalName === "contact";
}

function isOpportunity(entity: DynamicsEntity): entity is Opportunity {
    return entity.logicalName === "opportunity";
}

// Usage
function processEntity(entity: DynamicsEntity): void {
    if (isAccount(entity)) {
        console.log(`Account: ${entity.name}, Revenue: ${entity.revenue?.value}`);
    } else if (isContact(entity)) {
        console.log(`Contact: ${entity.firstname} ${entity.lastname}`);
    } else if (isOpportunity(entity)) {
        console.log(`Opportunity: ${entity.name}, Value: ${entity.estimatedvalue?.value}`);
    }
}
```
</details>

---

### Ćwiczenie 2: Async/Await (Mid)

**Zadanie:** Stwórz Web API helper z error handling

1. Implementuj `DynamicsAPI` class z metodami CRUD
2. Dodaj retry logic (max 3 attempts)
3. Dodaj timeout (5 seconds)
4. Obsłuż błędy HTTP (400, 401, 404, 500)
5. Zwracaj typowane responses

```typescript
class DynamicsAPI {
    async create<T>(entitySetName: string, entity: T): Promise<string> {
        // TODO: Implement with retry and timeout
    }
    
    async retrieve<T>(entitySetName: string, id: string): Promise<T> {
        // TODO: Implement with error handling
    }
}
```

**Wymagania:**
- Użyj async/await (nie `.then()`)
- Implementuj retry z exponential backoff
- Typuj wszystkie responses
- Obsłuż edge cases (network errors, timeouts)

---

### Ćwiczenie 3: DOM Manipulation (Mid)

**Zadanie:** Stwórz dynamiczną listę accounts z event delegation

1. Stwórz funkcję `renderAccountsList(accounts: Account[])`
2. Wyświetl każdy account jako card z: name, revenue, edit button, delete button
3. Użyj event delegation dla click handlers
4. Dodaj search/filter functionality
5. Dodaj loading state

**Funkcje do zaimplementowania:**
```typescript
function renderAccountsList(accounts: Account[]): void {
    // TODO: Render accounts as cards
}

function setupEventDelegation(): void {
    // TODO: Single event listener for all buttons
}

function filterAccounts(searchTerm: string): void {
    // TODO: Filter and re-render
}

function showLoading(show: boolean): void {
    // TODO: Show/hide spinner
}
```

**Bonus:** Dodaj pagination (10 items per page)

---

### Ćwiczenie 4: Form Scripting (Senior)

**Zadanie:** Stwórz kompletny form handler dla Account

**Wymagania:**
1. **OnLoad:**
   - Załaduj related contacts asynchronously
   - Setup field requirements based on category
   - Hide/show fields based on form type
   
2. **OnChange (revenue):**
   - Jeśli revenue > $1M, set category to "Enterprise"
   - Show warning notification
   - Call external API to verify large amounts
   
3. **OnSave:**
   - Validate required fields
   - Prevent save if validation fails
   - Show progress indicator during save

4. **Type Safety:**
   - Wszystkie operations typowane
   - Używaj proper interfaces dla form context
   - No `any` types!

```typescript
class AccountFormHandler {
    constructor(private formContext: FormContext) {}
    
    async onLoad(): Promise<void> {
        // TODO: Implement
    }
    
    async onRevenueChange(): Promise<void> {
        // TODO: Implement
    }
    
    onSave(saveEvent: any): void {
        // TODO: Implement
    }
}
```

---

### Ćwiczenie 5: Advanced Patterns (Senior)

**Zadanie:** Implementuj Repository Pattern z caching

Stwórz generic repository który:
1. Obsługuje CRUD operations
2. Cache'uje wyniki (in-memory)
3. Automatycznie invaliduje cache po update/delete
4. Implementuje retry logic
5. Jest fully typed

```typescript
interface CacheOptions {
    ttl: number; // Time to live in milliseconds
    maxSize: number;
}

class CachedRepository<T extends BaseEntity> {
    private cache: Map<string, { data: T; timestamp: number }>;
    
    constructor(
        private entitySetName: string,
        private cacheOptions: CacheOptions
    ) {
        this.cache = new Map();
    }
    
    async retrieve(id: string): Promise<T> {
        // TODO: Check cache first, then fetch if needed
    }
    
    async create(entity: T): Promise<string> {
        // TODO: Create and invalidate cache
    }
    
    async update(id: string, changes: Partial<T>): Promise<void> {
        // TODO: Update and invalidate cache
    }
    
    private invalidateCache(id: string): void {
        // TODO: Remove from cache
    }
    
    private cleanExpiredCache(): void {
        // TODO: Remove expired entries
    }
}
```

**Bonus:** Dodaj statistics (cache hit rate, miss rate)

---

## Checklist przed przejściem do Rozdziału 3

Przed przejściem do następnego rozdziału upewnij się że:

### TypeScript Fundamentals
- [ ] **Rozumiesz podstawowe typy**
  - [ ] Znasz różnicę między `string`, `number`, `boolean`
  - [ ] Potrafisz używać `any` vs `unknown` właściwie
  - [ ] Rozumiesz `null` vs `undefined`
  
- [ ] **Opanowałeś interfaces**
  - [ ] Potrafisz stworzyć interface dla entity
  - [ ] Rozumiesz optional properties (`?`)
  - [ ] Wiesz jak używać `readonly`
  - [ ] Potrafisz extend interfaces

- [ ] **Znasz union types i type guards**
  - [ ] Potrafisz stworzyć union type
  - [ ] Umiesz napisać custom type guard
  - [ ] Rozumiesz discriminated unions

### Modern JavaScript (ES6+)
- [ ] **Arrow functions**
  - [ ] Rozumiesz różnicę w `this` binding
  - [ ] Potrafisz używać concise syntax
  - [ ] Wiesz kiedy używać arrow vs traditional function

- [ ] **Destructuring**
  - [ ] Potrafisz destructure objects
  - [ ] Potrafisz destructure arrays
  - [ ] Umiesz używać rest operator (`...`)
  - [ ] Rozumiesz nested destructuring

- [ ] **Spread operator**
  - [ ] Potrafisz merge objects
  - [ ] Potrafisz copy arrays
  - [ ] Umiesz używać w function parameters

- [ ] **Template literals**
  - [ ] Potrafisz interpolować variables
  - [ ] Umiesz tworzyć multi-line strings
  - [ ] Rozumiesz tagged templates

### Asynchronous Programming
- [ ] **Promises**
  - [ ] Rozumiesz Promise states
  - [ ] Potrafisz tworzyć Promises
  - [ ] Umiesz chain promises
  - [ ] Wiesz jak obsłużyć errors

- [ ] **Async/Await**
  - [ ] Potrafisz konwertować Promise chains do async/await
  - [ ] Umiesz obsłużyć errors z try/catch
  - [ ] Rozumiesz Promise.all vs Promise.race
  - [ ] Unikasz common pitfalls (async void, blocking)

- [ ] **Error Handling**
  - [ ] Implementujesz retry logic
  - [ ] Obsługujesz timeouts
  - [ ] Logujesz errors properly
  - [ ] Używasz circuit breaker pattern gdzie potrzeba

### DOM Manipulation
- [ ] **Selectors**
  - [ ] Znasz różnicę getElementById vs querySelector
  - [ ] Potrafisz używać querySelectorAll
  - [ ] Rozumiesz NodeList vs Array

- [ ] **Event Handling**
  - [ ] Potrafisz dodawać/usuwać event listeners
  - [ ] Rozumiesz event delegation
  - [ ] Wiesz jak prevent default behavior
  - [ ] Umiesz handle różne event types

- [ ] **Element Manipulation**
  - [ ] Potrafisz tworzyć elements dynamically
  - [ ] Umiesz modyfikować attributes i styles
  - [ ] Rozumiesz classList API
  - [ ] Wiesz jak safely manipulate innerHTML

### Dynamics 365 Specific
- [ ] **Web API**
  - [ ] Potrafisz wykonać CRUD operations
  - [ ] Umiesz budować OData queries
  - [ ] Rozumiesz authentication headers
  - [ ] Wiesz jak handle pagination

- [ ] **Form Scripting**
  - [ ] Znasz form context API
  - [ ] Potrafisz get/set attribute values
  - [ ] Umiesz show/hide controls
  - [ ] Rozumiesz form events (OnLoad, OnSave, OnChange)

- [ ] **Type Safety**
  - [ ] Typujesz wszystkie Dynamics entities
  - [ ] Używasz interfaces dla form context
  - [ ] Unikasz `any` gdzie możliwe
  - [ ] Implementujesz type guards

### Best Practices
- [ ] **Code Quality**
  - [ ] Używasz TypeScript strict mode
  - [ ] Kod jest properly formatted
  - [ ] No console errors w browser
  - [ ] Wszystkie promises są handled

- [ ] **Error Handling**
  - [ ] Wszystkie async operations w try/catch
  - [ ] User-friendly error messages
  - [ ] Proper logging
  - [ ] Graceful degradation

- [ ] **Performance**
  - [ ] Unikasz memory leaks (event listeners removed)
  - [ ] Używasz event delegation
  - [ ] Cache'ujesz where appropriate
  - [ ] Debounce/throttle expensive operations

### Praktyka
- [ ] **Ćwiczenia**
  - [ ] Ukończyłeś wszystkie 5 ćwiczeń
  - [ ] Przetestowałeś kod w browser
  - [ ] Rozumiesz wszystkie przykłady
  - [ ] Eksperymentowałeś samodzielnie

---

## Podsumowanie rozdziału

W tym rozdziale poznałeś TypeScript i JavaScript w kontekście Power Platform:

✅ **TypeScript Basics** - types, interfaces, unions, type guards, type safety  
✅ **ES6+ Features** - arrow functions, destructuring, spread, template literals  
✅ **Async/Await** - promises, error handling, retry patterns, circuit breaker  
✅ **DOM Manipulation** - selectors, events, element creation, event delegation  
✅ **Type Safety** - entity interfaces, form context typing, generic repositories  

### Kluczowe wnioski:

> 💡 **TypeScript to must-have** - Type safety łapie błędy przed runtime

> 💡 **Async/await > Promises** - Czytelniejszy i łatwiejszy w maintenance

> 💡 **Event delegation** - Jeden listener zamiast setki

> 💡 **Type wszystko** - No `any`, używaj proper interfaces

> 💡 **Error handling is critical** - Zawsze obsługuj async errors

### Typowe pułapki do unikania:

❌ **Nie używaj `any`** - Tracisz type safety  
❌ **Nie ignoruj Promise rejections** - Unhandled rejections crashują app  
❌ **Nie dodawaj event listeners bez cleanup** - Memory leaks!  
❌ **Nie blokuj z `.wait()` lub `.Result`** - Deadlocks w async code  
❌ **Nie manipuluj DOM bez type guards** - `null` reference errors  

### Co dalej?

W **Rozdziale 3** poznasz **SQL i zapytania w Dynamics** - FetchXML, QueryExpression, optymalizację zapytań i best practices dla Dataverse.

---

