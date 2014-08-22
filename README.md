Ansible blockinfile Role
========================

Contains blockinfile module which might be useful
when you want to apply multi-line snippets in config files in /etc.

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

A playbook that prohibits SSH password authentication.

```yaml
---
- hosts: all
  remote_user: ansible-agent
  sudo: yes
  roles:
    - blockinfile
  tasks:
    - name: Prohibit SSH password authentication of SUDO_USER
      blockinfile: |
        dest=/etc/ssh/sshd_config backup=yes
        content='Match User {{ansible_env.SUDO_USER}}\nPasswordAuthentication no'
      notify: Restart sshd
  handlers:
    - name: Restart sshd
      service: name=ssh state=restarted
```

It will insert/update the following text block
in /etc/ssh/sshd_config, then restart sshd if needed.

```
# ANSIBLE MANAGED BLOCK BEGIN
Match User ansible-agent
PasswordAuthentication no
# ANSIBLE MANAGED BLOCK END
```

License
-------

GPLv3+

Author Information
------------------

https://github.com/yaegashi/ansible-blockinfile
