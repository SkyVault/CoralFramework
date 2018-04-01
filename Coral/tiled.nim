import 
    xmlparser, 
    xmltree, 
    streams,
    strutils,
    graphics,
    parseutils,
    os,
    game,
    ospaths

type
    TiledOrientation {.pure.} = enum
        Orthogonal,
        Orthographic

    TiledRenderorder {.pure.} = enum
        RightDown

    TiledObject* = ref object

    TiledTileset* = ref object
        name: string
        tilewidth, tileheight: int
        tilecount: int
        columns: int
        image: Image

    TiledLayer* = ref object
        name: string
        width, height: int
        tiles: seq[int]

    TiledMap* = ref object
        version: string
        tiledversion: string
        orientation: TiledOrientation
        renderorder: TiledRenderorder

        width, height: int
        tilewidth, tileheight: int
        infinite: bool

        tilesets: seq[TiledTileset]
        layers: seq[TiledLayer]

    
proc loadTileset* (path: string): TiledTileset=
    assert(fileExists path, "[ERROR] :: loadTiledMap :: Cannot find tileset: " & path)

    result = TiledTileset()
    let theXml = readFile(path)
        .newStringStream()
        .parseXml()
    
    result.name         = theXml.attr "name"
    result.tilewidth    = theXml.attr("tilewidth").parseInt
    result.tileheight   = theXml.attr("tileheight").parseInt
    result.tilecount    = theXml.attr("tilecount").parseInt
    result.tilecount    = theXml.attr("columns").parseInt

    let imageXml = theXml[0]
    let tpath = parentDir(path) & "/" & imageXml.attr("source")

    if not Coral.assets.imageExists tpath:
        result.image = CoralLoadImage tpath
        Coral.assets.add(tpath, result.image)
    else:
        result.image = Coral.assets.getImage tpath


proc loadTiledMap* (path: string): TiledMap=
    assert(fileExists path, "[ERROR] :: loadTiledMap :: Cannot find map: " & path)

    result = TiledMap(
        tilesets: newSeq[TiledTileset](),
        layers: newSeq[TiledLayer]()
    )

    let theXml = readFile(path)
        .newStringStream()
        .parseXml()

    result.version = theXml.attr "version"
    result.tiledversion = theXml.attr "tiledversion"

    result.orientation = 
        if theXml.attr("orientation") == "orthogonal":
            TiledOrientation.Orthogonal
        else:
            TiledOrientation.Orthogonal
        
    result.renderorder =
        if theXml.attr("renderorder") == "right-down":
            TiledRenderorder.RightDown
        else:
            TiledRenderorder.RightDown
        
    result.width = theXml.attr("width").parseInt
    result.height = theXml.attr("height").parseInt

    result.tilewidth = theXml.attr("tilewidth").parseInt
    result.tileheight = theXml.attr("tileheight").parseInt

    result.infinite = 
        if theXml.attr("infinite") == "0":
            false
        else:
            true

    let tileset_xmlnodes = theXml.findAll "tileset"
    for node in tileset_xmlnodes:
        let tpath = parentDir(path) & "/" & node.attr "source"
        result.tilesets.add loadTIleset(tpath)
    
    let layers_xmlnodes = theXml.findAll "layer"
    let objects_xmlnodes = theXml.findAll "objectgroup"

    for layerXml in layers_xmlnodes:
        let layer = TiledLayer(
            name: layerXml.attr "name",
            width: layerXml.attr("width").parseInt,
            height: layerXml.attr("height").parseInt,
        )

        layer.tiles = newSeq[int](layer.width * layer.height)

        let dataXml = layerXml[0][0]
        let dataText = dataXml.rawText
        let dataTextLen = dataText.len

        var cursor = 0
        var index = 0
        var token = ""

        while cursor < dataTextLen:
            cursor += parseUntil(dataText, token, ',', cursor) + 1
            token.removeSuffix()
            token.removePrefix()
            layer.tiles[index] = token.parseInt
            index += 1

        result.layers.add(layer)

    for objectsXml in objects_xmlnodes:
        discard """ TODO: Implement"""