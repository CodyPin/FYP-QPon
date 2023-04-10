migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("hpdbfkioo4axtwa")

  // update
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "lonntggh",
    "name": "amount",
    "type": "number",
    "required": false,
    "unique": false,
    "options": {
      "min": 1,
      "max": null
    }
  }))

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("hpdbfkioo4axtwa")

  // update
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "lonntggh",
    "name": "amount",
    "type": "number",
    "required": true,
    "unique": false,
    "options": {
      "min": 1,
      "max": null
    }
  }))

  return dao.saveCollection(collection)
})
