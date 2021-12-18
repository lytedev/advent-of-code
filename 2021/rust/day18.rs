#![warn(clippy::all, clippy::pedantic)]

mod common;
use common::day_input;

type ChildNode<T> = Box<BinaryTreeNode<T>>;

#[derive(Debug, std::cmp::PartialEq)]
struct BinaryTreeBranch<T> {
    left: ChildNode<T>,
    right: ChildNode<T>,
}

#[derive(Debug, std::cmp::PartialEq)]
enum BinaryTreeNode<T> {
    Branch(BinaryTreeBranch<T>),
    Leaf(T),
}

fn crawl_for<T>(node: &BinaryTreeNode<T>, predicate: fn(&BinaryTreeNode<T>, u64) -> bool, current_depth: u64) -> Option<&BinaryTreeNode<T>> {
    if predicate(node, current_depth) {
        Some(node)
    } else if let BinaryTreeNode::Branch(branch) = node {
        if let Some(result) = crawl_for(&*branch.left, predicate, current_depth + 1) {
            Some(result)
        } else if let Some(result) = crawl_for(&*branch.right, predicate, current_depth + 1) {
            Some(result)
        } else {
            None
        }
    } else {
        None
    }
}

fn maybe_explode<T: std::fmt::Debug>(tree: &mut BinaryTreeNode<T>) -> bool {
    if let Some(node_to_explode) = crawl_for(tree, |node, d| {
        if let BinaryTreeNode::Branch(_) = node {
            // TODO: must both child nodes be leaves?
            d >= 3
        } else {
            false
        }
    }, 0) {
        // TODO: do explosion
        println!("{:#?}", node_to_explode);
        true
    } else { 
        false
    }
}

fn parse_binary_tree(s: &str) -> Result<BinaryTreeNode<u64>, &'static str> {
    let chars = s.chars().peekable();
    let ch = chars.peek();
    if let Some(c) = ch {
        match c {
            '0'..='9' => Ok(BinaryTreeNode::Leaf(u64::from(*c) - ASCII_0))
            '[' => {
                it.next()
                parse_binary_tree(
                // TODO: parse left piece
                // TODO: parse right piece
                // do_parse_binary_tree(&s[1..], depth + 1)
                // TODO: parse end of this (']')
            }
            _ => Err("unknown char")
        }
    } else {
        Err("empty string")
    }
}

fn main() {
    let result = parse_binary_tree(&day_input(18));
    println!("Snailfish Homework: {:#?}", result);
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parser() {
        assert_eq!(parse_binary_tree("y"), Err("unknown char"));
        assert_eq!(parse_binary_tree("9"), Ok(BinaryTreeNode::Leaf(9)));
        assert_eq!(parse_binary_tree("[[1,2],3]"), Ok(BinaryTreeNode::Branch(BinaryTreeBranch {
            left: Box::new(BinaryTreeNode::Branch(BinaryTreeBranch { 
                left: Box::new(BinaryTreeNode::Leaf(1)),
                right: Box::new(BinaryTreeNode::Leaf(2)),
            })),
            right: Box::new(BinaryTreeNode::Leaf(3)),
        })));
    }

    #[test]
    fn needs_exploding() {
    }
}
