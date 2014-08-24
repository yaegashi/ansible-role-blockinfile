Ansible Role: blockinfile
=========================

This role contains no tasks, but provides blockinfile module
which might be useful when you want to apply multi-line snippets
in config files in /etc.


Requirements
------------

None.

Role Variables
--------------

None.

Dependencies
------------

None.

Example Playbook
----------------

Simple task with YAML block literal:

```yaml
- blockinfile: |
    dest=/etc/network/interfaces backup=yes
    content="iface eth0 inet static
        address 192.168.0.1
        netmask 255.255.255.0"
```

It will insert/update the following text block in /etc/network/interfaces:

```
# BEGIN ANSIBLE MANAGED BLOCK
iface eth0 inet static
    address 192.168.0.1
    netmask 255.255.255.0
# END ANSIBLE MANAGED BLOCK
```

Another task with alternative marker lines and variable substitution:

```yaml
- blockinfile: |
    dest=/var/www/html/index.html backup=yes
    marker="<!-- {mark} ANSIBLE MANAGED BLOCK -->"
    content="<h1>Welcome to {{ansible_hostname}}</h1>"
```

Complete playbook
that makes SSH password authentication for specific user prohibited,
then restarts sshd if needed.

```yaml
---
- hosts: all
  remote_user: ansible-agent
  sudo: yes
  roles:
    - yaegashi.blockinfile
  tasks:
    - name: Prohibit SSH password authentication for $SUDO_USER
      blockinfile: |
        dest=/etc/ssh/sshd_config backup=yes
        content='Match User {{ansible_env.SUDO_USER}}\nPasswordAuthentication no'
      notify: Restart sshd
  handlers:
    - name: Restart sshd
      service: name=ssh state=restarted
```

License
-------

GPLv3+

Author Information
------------------

https://github.com/yaegashi/ansible-blockinfile
