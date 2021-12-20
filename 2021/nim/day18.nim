import ./common, std/[sequtils, algorithm, sugar, sets, strformat, strutils, tables, options, json]

type
  BinaryTreeNodePathSegment = enum left, right
  BinaryTreeNodePath = seq[BinaryTreeNodePathSegment]
  BinaryTreeNodeKind = enum
    leaf
    branch
  BinaryTreeNode = ref BinaryTreeNodeObj
  BinaryTreeNodeObj = object
    case kind: BinaryTreeNodeKind
    of leaf: value: uint64
    of branch: left, right: BinaryTreeNode
  BinaryTreeNodeParseResult = object
    node: BinaryTreeNodeObj
    parsed_length: uint64

proc parseBinaryTree(s: string): (BinaryTreeNode, uint64) =
  case s[0]:
    of '0'..'9': result = (BinaryTreeNode(kind: leaf, value: uint8(s[0]) - uint8('0')), 1'u64)
    of '[':
      let (left, leftLen) = parseBinaryTree(s[1..^1])
      let (right, righLen) = parseBinaryTree(s[2+leftLen..^1])
      result = (BinaryTreeNode(kind: branch, left: left, right: right), 3'u64 + leftLen + righLen)
    else:
      echo "unexpected string"

proc `$`(node: BinaryTreeNode): string =
  case node.kind:
    of leaf: result = $node.value
    of branch: result = &"[{$node.left},{$node.right}]"

when not defined(release):
  block:
    let (bt, n) = parseBinaryTree("[[1,2],3]")
    assert bt.right.value == 3'u64
    assert bt.left.left.value == 1'u64
    assert bt.left.right.value == 2'u64
    assert n == 9

proc nodeAt(node: BinaryTreeNode, path: BinaryTreeNodePath): Option[BinaryTreeNode] =
  var curNode = node
  for p in path:
    if curNode.kind == leaf: return none(BinaryTreeNode)
    case p:
      of left: curNode = curNode.left
      of right: curNode = curNode.right
  return some(curNode)

when not defined(release):
  block:
    let (bt, _) = parseBinaryTree("[[1,2],3]")
    let n = bt.nodeAt(@[right]).get
    assert n.kind == leaf
    assert n.value == 3
    let n2 = bt.nodeAt(@[left]).get
    assert n2.kind == branch
    assert n2.left.value == 1
    assert n2.right.value == 2
    let n3 = bt.nodeAt(@[left, right]).get
    assert n3.kind == leaf
    assert n3.value == 2
    let n4 = bt.nodeAt(@[left, left]).get
    assert n4.kind == leaf
    assert n4.value == 1
    let (bt2, _) = parseBinaryTree("[[[[[8,[1,2]],3],4],7],6]")
    let n5 = bt2.nodeAt(@[left, left, left, left, left]).get()
    assert n5.value == 8
    let n6 = bt2.nodeAt(@[left, left, left, left, right, left]).get()
    assert n6.value == 1

proc updateNode(node: var BinaryTreeNode, path: BinaryTreeNodePath, callback: (BinaryTreeNode) -> BinaryTreeNode) =
  var curNode = node
  var walker = path.reversed()
  while walker.len() > 1:
    case walker.pop():
      of left: curNode = curNode.left
      of right: curNode = curNode.right
  # TODO: handle empty path?
  case walker.pop():
    of left: curNode.left = callback(curNode.left)
    of right: curNode.right = callback(curNode.right)

when not defined(release):
  block:
    var (bt, _) = parseBinaryTree("[[1,2],3]")
    bt.updateNode(@[left], (_) => BinaryTreeNode(kind: leaf, value: 4'u64))
    assert bt.left.kind == leaf
    assert bt.left.value == 4
    assert bt.right.kind == leaf
    assert bt.right.value == 3

proc crawlFor(node: BinaryTreeNode, predicate: (node: BinaryTreeNode, path: BinaryTreeNodePath) -> bool, path: BinaryTreeNodePath = @[], preferredSide: BinaryTreeNodePathSegment = left): Option[BinaryTreeNodePath] =
  if node.predicate(path):
    return some(path)
  elif node.kind == branch:
    if preferredSide == left:
      let ln = node.left.crawlFor(predicate, path & @[left], preferredSide)
      if ln.isSome: return ln
      let rn = node.right.crawlFor(predicate, path & @[right], preferredSide)
      if rn.isSome: return rn
    else:
      let rn = node.right.crawlFor(predicate, path & @[right], preferredSide)
      if rn.isSome: return rn
      let ln = node.left.crawlFor(predicate, path & @[left], preferredSide)
      if ln.isSome: return ln
  return none(BinaryTreeNodePath)

when not defined(release):
  block:
    var (bt, _) = parseBinaryTree("[[1,2],3]")
    assert bt.crawlFor((_, p) => p.len() > 4).isNone
    var (bt2, _) = parseBinaryTree("[[[[[9,8],1],2],3],8]")
    var p = bt2.crawlFor((n, p) => p.len() > 4 and n.kind == leaf and n.value == 8'u64, @[], right)
    assert p.isSome
    assert p.get == @[left, left, left, left, right]

proc valueLeftOf(node: BinaryTreeNode, path: BinaryTreeNodePath): Option[BinaryTreeNodePath] =
  var walker = path
  while walker.len > 0:
    if walker.pop == right:
      let subPath = walker & @[left]
      let subNode = node.nodeAt(subPath)
      if subNode.isSome:
        let candidatePath = subNode.get.crawlFor((n, _) => n.kind == leaf, @[], right)
        if candidatePath.isSome: return some(subPath & candidatePath.get)
  # echo &"No lefter value node"
  return none(BinaryTreeNodePath)

when not defined(release):
  block:
    let (bt, _) = parseBinaryTree("[[1,2],3]")
    assert bt.valueLeftOf(@[right]) == some(@[left, right])
    assert bt.valueLeftOf(@[left, left]) == none(BinaryTreeNodePath)
    assert bt.valueLeftOf(@[left, right]) == some(@[left, left])
    let (bt2, _) = parseBinaryTree("[1,[2,3]]")
    assert bt2.valueLeftOf(@[right, right]) == some(@[right, left])
    assert bt2.valueLeftOf(@[right, left]) == some(@[left])

proc valueRightOf(node: BinaryTreeNode, path: BinaryTreeNodePath): Option[BinaryTreeNodePath] =
  var walker = path
  while walker.len > 0:
    if walker.pop == left:
      let subPath = walker & @[right]
      let subNode = node.nodeAt(subPath)
      if subNode.isSome:
        let candidatePath = subNode.get.crawlFor((n, _) => n.kind == leaf, @[], left)
        if candidatePath.isSome: return some(subPath & candidatePath.get)
  # echo &"No righter value node"
  return none(BinaryTreeNodePath)

proc isExplodeCandidate(n: BinaryTreeNode, p: BinaryTreeNodePath): bool =
  ((p.len() >= 4) and (n.kind == branch) and (n.left.kind == leaf) and (n.right.kind == leaf))

proc doExplode(node: var BinaryTreeNode): bool =
  let explodePath = node.crawlFor(isExplodeCandidate)
  if explodePath.isSome:
    let explodingPair = node.nodeAt(explodePath.get).get
    let lp = node.valueLeftOf(explodePath.get)
    let rp = node.valueRightOf(explodePath.get)
    if lp.isSome:
      node.updateNode(lp.get, (n) => BinaryTreeNode(kind: leaf, value: n.value + explodingPair.left.value))
    if rp.isSome:
      node.updateNode(rp.get, (n) => BinaryTreeNode(kind: leaf, value: n.value + explodingPair.right.value))
    node.updateNode(explodePath.get, (_) => BinaryTreeNode(kind: leaf, value: 0))
  explodePath.isSome

when not defined(release):
  block:
    var (bt, _) = parseBinaryTree("[[[[[9,8],1],2],3],4]")
    let didExplode = bt.doExplode
    assert didExplode == true
    assert bt.left.left.left.left.kind == leaf
    assert bt.left.left.left.left.value == 0

proc splitAt(node: var BinaryTreeNode, path: BinaryTreeNodePath) =
  let splittingValue = node.nodeAt(path).get
  let lv = splittingValue.value div 2
  let rv = lv + (splittingValue.value mod 2)
  node.updateNode(path, (_) => BinaryTreeNode(
    kind: branch,
    left: BinaryTreeNode(kind: leaf, value: lv),
    right: BinaryTreeNode(kind: leaf, value: rv),
  ))

proc doSplit(node: var BinaryTreeNode): bool = 
  let splitPath = node.crawlFor((n, _) => n.kind == leaf and n.value >= 10)
  if splitPath.isSome: node.splitAt splitPath.get
  splitPath.isSome

proc magnitude(node: BinaryTreeNode): uint64 =
  case node.kind:
    of leaf: node.value
    else: (3 * node.left.magnitude) + (2 * node.right.magnitude)

proc reduceTree(bt: var BinaryTreeNode) =
  while true:
    if bt.doExplode: continue
    if bt.doSplit: continue
    break

proc `+`(addend1: BinaryTreeNode, addend2: BinaryTreeNode): BinaryTreeNode =
  result = BinaryTreeNode(kind: branch, left: addend1, right: addend2)
  result.reduceTree()

when not defined(release):
  block:
    var (bt1, _) = parseBinaryTree("[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]")
    assert $bt1 == "[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]"
    var (bt2, _) = parseBinaryTree("[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]")
    var a = bt1 + bt2
    assert $a == "[[[[7,8],[6,6]],[[6,0],[7,7]]],[[[7,8],[8,8]],[[7,9],[0,6]]]]"

proc p1(input: Lines): uint64 =
  input.mapIt(it.parseBinaryTree[0]).foldl(a + b).magnitude

proc p2(input: Lines): uint64 =
  for i,p1 in input.pairs:
    for j,p2 in input.pairs:
      if i == j: continue
      let (b1, _) = p1.parseBinaryTree
      let (b2, _) = p2.parseBinaryTree
      let a = b1 + b2
      let m = a.magnitude
      result = max(m, result)

const input = """
[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
[[[5,[2,8]],4],[5,[[9,9],0]]]
[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
[[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
[[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
[[[[5,4],[7,7]],8],[[8,3],8]]
[[9,3],[[9,9],[6,[4,9]]]]
[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
[[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
""".strip().split('\n').mapIt(it.strip)
doDayX 18, (n: int) => n.loadInput, p1, p2, (input, 4140'u64, 3993'u64)
