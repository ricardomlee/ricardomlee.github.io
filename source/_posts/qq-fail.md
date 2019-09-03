---
title: 鹅肠一面凉
date: 2019-09-03 19:16:10
tags: 面试
---

## 三道手撕代码，半小时

### 反转单链表（逃）
要求能获取到反转后链表的头节点，自己写的时候没有注意到，而是新建了临时节点
```C++
struct ListNode{
    int val;
    struct ListNode* next;
}
void ReverseList(struct ListNode* head)
{
    ListNode *prev=nullptr;
    
    while(head!=nullptr){
        ListNode *pNext=head->next;
        head->next=prev;
        prev=head;
        head=pNext;
    }
    head=prev;
}
```

### 二叉搜索树转换成双向链表（崩）
#### 1.利用递归
面试一上来被整蒙了，思路没有讲清楚，代码也没撕出来，现在重新整理一下
对于根节点，先将左子树转换成双向链表，根节点的左指针指向该表最右节点，该节点右指针指向根节点
将右子树转换成双向链表，根节点的右指针指向该表最左节点，该节点左指针指向根节点
指针向左移动直到左指针为空，返回头节点
```C++
#include <iostream>

struct BinaryTreeNode
{
    int val;
    BinaryTreeNode* left;
    BinaryTreeNode* right;
    BinaryTreeNode(int x):val(x),left(nullptr),right(nullptr) {};
};

BinaryTreeNode* Convert(BinaryTreeNode* root)
{
    if(root==nullptr)
        return nullptr;
    if(root->left==nullptr&&root->right==nullptr)
        return root;
    BinaryTreeNode *pleft=Convert(root->left);
    BinaryTreeNode *p=pleft;
    while(p!=nullptr&&p->right!=nullptr){
        p=p->right;
    }
    if(pleft!=nullptr){
        p->right=root;
        root->left=p;
    }
    BinaryTreeNode *pright=Convert(root->right);
    if(pright!=nullptr){
        pright->left=root;
        root->right=pright;
    }
    return (pleft==nullptr)?root:pleft;
}

int main()
{
    BinaryTreeNode *a1=new BinaryTreeNode(1);
    BinaryTreeNode *a2=new BinaryTreeNode(2);
    BinaryTreeNode *a3=new BinaryTreeNode(3);
    BinaryTreeNode *a4=new BinaryTreeNode(4);
    BinaryTreeNode *a5=new BinaryTreeNode(5);
    BinaryTreeNode *a6=new BinaryTreeNode(6);
    BinaryTreeNode *a7=new BinaryTreeNode(7);

    a4->left=a2;
    a4->right=a6;
    a2->left=a1;
    a2->right=a3;
    a6->left=a5;
    a6->right=a7;

    BinaryTreeNode *BList=Convert(a4);
    while(BList->right!=nullptr){
        std::cout<<BList->val<<std::endl;
        BList=BList->right;
    }
    return 0;
}
```

#### 2.中序遍历
这是一开始的想法，太慌了也没写出来...
二叉树的中序遍历：
```C++
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode(int x) : val(x), left(NULL), right(NULL) {}
 * };
 */
class Solution {
public:
    vector<int> inorderTraversal(TreeNode* root) {
        vector<int> mid;
        stack<TreeNode*> s;
        TreeNode *node=root;
        while(node!=nullptr||!s.empty()){
            if(node!=nullptr){
                s.push(node);
                node=node->left;
            }
            else{
                node=s.top();
                s.pop();
                mid.push_back(node->val);
                node=node->right;
            }
        }
        return mid;
    }
};
```
本题的非递归方法(待补充)

### 求平方根（数学渣&*&^%）
牛顿迭代法
```C++
#include<iostream>
using namespace std;
double sqrt(int x)
{
    if(x==0)
        return 0;
    double last=0.0;
    double root=1.0;
    while(root!=last){
        last=root;
        root=(root+x/root)/2;
    }
    return root;
}

int main()
{
    int x;
    while(cin>>x){
        cout<<sqrt(x)<<endl;
    }
    return 0;
}
```