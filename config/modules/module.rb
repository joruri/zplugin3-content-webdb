Cms::Lib::Modules::ModuleSet.draw :webdb, '検索DB', 999 do |mod|
#  ## contents
  mod.content :dbs, 'データベース'

#  ## directories
  mod.directory :dbs, 'データベース検索'

  ## pieces
  mod.piece :forms   ,  '項目検索フォーム'
  mod.piece :maps    ,  'マップ検索フォーム'
  mod.piece :groups  ,  'カテゴリ検索フォーム'
  mod.piece :spaces  ,  '空き枠検索フォーム'

end