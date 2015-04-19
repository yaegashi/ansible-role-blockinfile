Ansible Role: blockinfile
=========================

This role contains no tasks, but provides blockinfile module
which might be useful when you want to apply multi-line snippets
in config files in /etc.

Ansible Galaxy Page: [https://galaxy.ansible.com/list#/roles/1475](https://galaxy.ansible.com/list#/roles/1475)

blockinfile Module
------------------

### Options

If this section doesn't show nicely in Ansible Galaxy Page,
please refer to equeivalent in
[GitHub Page](https://github.com/yaegashi/ansible-role-blockinfile#options).

<table border=1 cellpadding=4>
<tr>
<th class="head">parameter</th>
<th class="head">required</th>
<th class="head">default</th>
<th class="head">choices</th>
<th class="head">comments</th>
</tr>
<tr>
<td>backup</td>
<td>no</td>
<td>no</td>
<td><ul><li>yes</li><li>no</li></ul></td>
<td>Create a backup file including the timestamp information so you can get the original file back if you somehow clobbered it incorrectly.</td>
</tr>
<tr>
<td>content</td>
<td>no</td>
<td></td>
<td><ul></ul></td>
<td>The text to insert inside the marker lines. If it's empty string, marker lines will also be removed.</td>
</tr>
<tr>
<td>create</td>
<td>no</td>
<td>no</td>
<td><ul><li>yes</li><li>no</li></ul></td>
<td>Create a new file if it doesn't exist.</td>
</tr>
<tr>
<td>dest</td>
<td>yes</td>
<td></td>
<td><ul></ul></td>
<td>The file to modify.</td>
</tr>
<tr>
<td>follow</td>
<td>no</td>
<td>no</td>
<td><ul><li>yes</li><li>no</li></ul></td>
<td>This flag indicates that filesystem links, if they exist, should be followed. (added in Ansible 1.8)</td>
</tr>
<tr>
<td>group</td>
<td>no</td>
<td></td>
<td><ul></ul></td>
<td>name of the group that should own the file/directory, as would be fed to <em>chown</em></td>
</tr>
<tr>
<td>marker</td>
<td>no</td>
<td># {mark} ANSIBLE MANAGED BLOCK</td>
<td><ul></ul></td>
<td>The marker line template. "{mark}" will be replaced with "BEGIN" or "END".</td>
</tr>
<tr>
<td>mode</td>
<td>no</td>
<td></td>
<td><ul></ul></td>
<td>mode the file or directory should be, such as 0644 as would be fed to <em>chmod</em>. As of version 1.8, the mode may be specified as a symbolic mode (for example, <code>u+rwx</code> or <code>u=rw,g=r,o=r</code>).</td>
</tr>
<tr>
<td>owner</td>
<td>no</td>
<td></td>
<td><ul></ul></td>
<td>name of the user that should own the file/directory, as would be fed to <em>chown</em></td>
</tr>
<tr>
<td>selevel</td>
<td>no</td>
<td>s0</td>
<td><ul></ul></td>
<td>level part of the SELinux file context. This is the MLS/MCS attribute, sometimes known as the <code>range</code>. <code>_default</code> feature works as for <em>seuser</em>.</td>
</tr>
<tr>
<td>serole</td>
<td>no</td>
<td></td>
<td><ul></ul></td>
<td>role part of SELinux file context, <code>_default</code> feature works as for <em>seuser</em>.</td>
</tr>
<tr>
<td>setype</td>
<td>no</td>
<td></td>
<td><ul></ul></td>
<td>type part of SELinux file context, <code>_default</code> feature works as for <em>seuser</em>.</td>
</tr>
<tr>
<td>seuser</td>
<td>no</td>
<td></td>
<td><ul></ul></td>
<td>user part of SELinux file context. Will default to system policy, if applicable. If set to <code>_default</code>, it will use the <code>user</code> portion of the policy if available</td>
</tr>
<tr>
<td>validate</td>
<td>no</td>
<td>None</td>
<td><ul></ul></td>
<td>validation to run before copying into place</td>
</tr>
</table>

### Examples

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

### TODO

- Add insertafter/insertbefore options
to insert a block at an arbitrary position.


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

[YAEGASHI Takeshi](https://github.com/yaegashi)
