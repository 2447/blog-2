# 八卦博客 · 安装部署
## 如何安装

1.  安装 node.js ([安装教程](http://www.runoob.com/nodejs/nodejs-install-setup.html)) 和 git ([安装教程](https://git-scm.com/book/zh/v2/%E8%B5%B7%E6%AD%A5-%E5%AE%89%E8%A3%85-Git))
2.  npm install -g 8gua --registry=[https://registry.npm.taobao.org](https://registry.npm.taobao.org)
3.  创建并克隆页面仓库（如： [码云页面](http://git.mydoc.io/?t=154714) 、[GITHUB PAGE](https://pages.github.com/) 、[BITBUCKET PAGE](https://pages.bitbucket.io/) ）
    
4.  到仓库目录下执行 8gua
    

## 部署到私有服务器

静态博客，自然可以随处部署。

nginx配置文件[参考这里](https://gitee.com/u8gua/tool/blob/master/nginx.8gua.conf) ，其中用到的https免费证书，可使用 [acme.sh](https://github.com/Neilpang/acme.sh/wiki/%E8%AF%B4%E6%98%8E) 来自动生成。

caddy配置文件[参考这里](https://gitee.com/u8gua/tool/blob/master/Caddyfile)。

### 持续集成

持续集成，就是当后台自动push修改后，私有服务器上自动更新网页。

可以使用[Travis CI](https://travis-ci.org/)配合github来实现此需求。

1.  访问 [travis-ci.com](https://travis-ci.com/) ，打开项目构建开关
    
2.  在本机安装travis (先确保ruby已经安装，gem命令可用)。  
    sudo gem install travis
    
3.  运行 travis login ， 输入github的用户名密码。
    
4.  在仓库根目录新建 .travis.yml ，并git add
    
5.  用travis加密添加登录是有服务器的私钥到仓库
    
    `travis encrypt-file ~/.ssh/id_rsa --add`
    
    `git add id_rsa.enc`
    
    然后，请把 .travis.yml 中 openssl 这一行的 ~\\/.ssh 改为 ~/.ssh
    
6.  在私有服务器上git clone代码仓库到目录
    
7.  参考[此配置文件](https://gitee.com/u8gua/tool/blob/master/.travis.yml)，修改你的.travis.yml
    
8.  push仓库，即可实现自动触发更新
    

#### 拓展阅读

*   [持续集成服务 Travis CI 教程](http://www.ruanyifeng.com/blog/2017/12/travis_ci_tutorial.html)