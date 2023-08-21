# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Feelis.Repo.insert!(%Feelis.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

%{id: presentation_id} =
  Feelis.Repo.insert!(%Feelis.Presentations.Presentation{
    title: "Very first presentation",
    inserted_at: ~N[2000-01-01 23:00:07],
    updated_at: ~N[2000-01-01 23:00:07]
  })

Feelis.Repo.insert!(%Feelis.Presentations.Slide{
  title: "Slide 1",
  description: "Please write your answer now",
  presentation_id: presentation_id,
  inserted_at: ~N[2000-01-01 23:00:07],
  updated_at: ~N[2000-01-01 23:00:07]
})

%{id: slide_id} =
  Feelis.Repo.insert!(%Feelis.Presentations.Slide{
    title: "Slide 2",
    description: "Do it now!",
    presentation_id: presentation_id,
    inserted_at: ~N[2000-01-01 23:00:07],
    updated_at: ~N[2000-01-01 23:00:07]
  })

Feelis.Repo.insert!(%Feelis.Presentations.Answer{
  slide_id: slide_id,
  answer: "Yep",
  user_id: "1234",
  inserted_at: ~N[2000-01-01 23:00:07],
  updated_at: ~N[2000-01-01 23:00:07]
})

Feelis.Repo.insert!(%Feelis.Presentations.Answer{
  slide_id: slide_id,
  answer: "Nope",
  user_id: "1234",
  inserted_at: ~N[2000-01-01 23:00:07],
  updated_at: ~N[2000-01-01 23:00:07]
})

Feelis.Repo.insert!(%Feelis.Presentations.Answer{
  slide_id: slide_id,
  answer: "Unsure",
  user_id: "1234",
  inserted_at: ~N[2000-01-01 23:00:07],
  updated_at: ~N[2000-01-01 23:00:07]
})
