spec:
  template:
    spec:
      containers:
      - name: stunnel
        image: dweomer/stunnel
        volumeMounts:
        - name: stunnel-config
          mountPath: /etc/stunnel
        command:
        - stunnel
      volumes:
      - name: stunnel-config
        configMap:
          name: ${configmap_name}
