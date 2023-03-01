#  APICaller DOCS

## How to use

Чтобы получить данные, необходимо обратиться к APICaller.

Пример запроса:

    APICaller.shared.getSortedRecipes(type: .popular) { results in
        switch results {
        case .success(let recipes):
            // Успешно получено
            
            APICaller.shared.getDetailedRecipe(with: recipes[0].id) { results in
            switch results {
            case .success(let recipe):
                // успешно получены детальные данные
            case .failure(let error):
                print(error)
                // получена ошибка при запросе детальных данных
            }
        }
        case .failure(let error): 
            print (error)
            // получена ошибка
        }
    }

    - APICaller.shared.getSortedRecipes(type: <указываем категорию рецепта>)
    

