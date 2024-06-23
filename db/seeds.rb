# frozen_string_literal: true

if Rails.env.development?
  user = User.find_or_initialize_by(
    email: 'admin@remedium.band'
  )
  user.password = 'ibuprom'
  user.password_confirmation = 'ibuprom'
  user.admin = true
  user.first_name = 'Administrator'
  user.last_name = 'Systemu'
  user.save!

  Setting.find_or_create_by!(
    meta_title: 'Oficjalna strona zespołu Remedium',
    meta_tags: 'bydgoszcz,rock,metal,music,guitars,drums,vocals,' \
               'zespol rockowy,polski zespol rockowy,' \
               'polski rock, polish rock, polish rock band,' \
               'polish rock band bydgoszcz,polski zespol rockowy bydgoszcz',
    meta_description: "Zespół Remedium - koncerty, płyty, booking. Posłuchaj naszej EP 'Przebudzenie'.",
    contact_email: 'remedium.bydgoszcz@gmail.com',
    facebook_url: 'https://www.facebook.com/remedium.bydgoszcz',
    youtube_url: 'https://www.youtube.com/@remedium-bydgoszcz'
  )
end
