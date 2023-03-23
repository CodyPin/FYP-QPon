migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("1z9rx49vuw712hl")

  // update
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "in8npngo",
    "name": "image",
    "type": "file",
    "required": false,
    "unique": false,
    "options": {
      "maxSelect": 1,
      "maxSize": 5242880,
      "mimeTypes": [
        "image/jpeg",
        "image/vnd.mozilla.apng",
        "image/png"
      ],
      "thumbs": []
    }
  }))

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("1z9rx49vuw712hl")

  // update
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "in8npngo",
    "name": "image",
    "type": "file",
    "required": false,
    "unique": false,
    "options": {
      "maxSelect": 1,
      "maxSize": 5242880,
      "mimeTypes": [],
      "thumbs": []
    }
  }))

  return dao.saveCollection(collection)
})
