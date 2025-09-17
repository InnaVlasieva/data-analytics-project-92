cars = { 
    "Toyota Camry": [2020, "бензиновый", "2.5 л", "7.5 л/100 км"],
    "Tesla Model 3": [2021, "электрический", "электро", "15 кВт·ч/100 км"],
    "BMW X5": [2019, "дизельный", "3.0 л", "8.2 л/100 км"],
    "Audi A6": [2020, "бензиновый", "3.0 л", "7.9 л/100 км"],
    "Mercedes-Benz E-Class": [2021, "дизельный", "2.0 л", "6.5 л/100 км"],
    "Hyundai Tucson": [2022, "бензиновый", "2.0 л", "7.0 л/100 км"],
    "Kia Sportage": [2021, "дизельный", "2.0 л", "6.8 л/100 км"],
    "Volkswagen Golf": [2019, "бензиновый", "1.4 л", "6.2 л/100 км"],
    "Ford Focus": [2020, "бензиновый", "1.0 л", "5.8 л/100 км"],  
    "Nissan Leaf": [2021, "электрический", "электро", "17 кВт·ч/100 км"]
}

def analyze_car(model, data):
    year, engine_type, volume, fuel = data
    
    match (engine_type, year):
        case ("электрический", _):
            return f"{model}: Современный электрокар ({year})"
        case ("дизельный", y) if y < 2020:
            return f"{model}: Старый дизель ({year})"
        case ("бензиновый", y) if y >= 2020:
            return f"{model}: Современный бензиновый ({year})"
        case _:
            return f"{model}: Другой вариант ({year}, {engine_type})"

# Проверим для всех машин
for model, data in cars.items():
    print(analyze_car(model, data))
