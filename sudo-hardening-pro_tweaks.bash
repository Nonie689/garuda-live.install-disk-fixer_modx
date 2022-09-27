
sudo sed -i "s/auth.*sufficient.*pam_wheel.so trust use_uid/auth required pam_wheel.so trust use_uid/g" /etc/pam.d/su &> /dev/null
sudo bash -c "echo '%wheel  ALL=(ALL) ALL' > /etc/sudoers.d/g_wheel" &> /dev/null
cat /etc/sudoers | grep pwfeedback &> /dev/null || sudo bash -c "printf '\nDefaults env_reset,pwfeedback' >> /etc/sudoers" &> /dev/null
