alias Example.Repo
alias Example.User

users =[
  {"Yamada","Taro",20},
  {"Sato","Hanako",18},
  {"Suzuki","Jiro",23}
]

Enum.each(users,fn {last_name, first_name, age} ->
  user =
    %User{
      first_name: first_name,
      last_name: last_name,
      age: age,
      email: first_name <> "@example.com"
    }

    Repo.insert!(user)
  end)
