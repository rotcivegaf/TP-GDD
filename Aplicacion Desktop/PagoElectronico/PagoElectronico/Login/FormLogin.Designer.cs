using System.Windows.Forms;

namespace PagoElectronico.ABM_Rol
{
    partial class FormLogin
    {

        private Button boton_ingresar, boton_salir;
        private Label label_user, label_password;
        private TextBox textbox_user, textbox_password;


        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            boton_ingresar = new Button();
            boton_salir = new Button();
            label_user = new Label();
            label_password = new Label();
            textbox_user = new TextBox();
            textbox_password = new TextBox();
            this.SuspendLayout();

            label_user.AutoSize = true;
            label_user.Location = new System.Drawing.Point(20, 22);
            label_user.Name = "label_user";
            label_user.Size = new System.Drawing.Size(46, 13);
            label_user.TabIndex = 2;
            label_user.Text = "Usuario:";


            label_password.AutoSize = true;
            label_password.Location = new System.Drawing.Point(20, 56);
            label_password.Name = "label_password";
            label_password.Size = new System.Drawing.Size(64, 13);
            label_password.TabIndex = 3;
            label_password.Text = "Contraseña:";


            textbox_user.Location = new System.Drawing.Point(125, 19);
            textbox_user.Name = "textbox_user";
            textbox_user.Size = new System.Drawing.Size(130, 20);
            textbox_user.TabIndex = 4;


            textbox_password.Location = new System.Drawing.Point(125, 53);
            textbox_password.Name = "textbox_password";
            textbox_password.PasswordChar = '*';
            textbox_password.Size = new System.Drawing.Size(130, 20);
            textbox_password.TabIndex = 5;

           
            boton_ingresar.Location = new System.Drawing.Point(190, 129);
            boton_ingresar.Name = "boton_ingresar";
            boton_ingresar.Size = new System.Drawing.Size(75, 23);
            boton_ingresar.TabIndex = 0;
            boton_ingresar.Text = "Ingresar";


            boton_salir.Location = new System.Drawing.Point(17, 128);
            boton_salir.Name = "boton_salir";
            boton_salir.Size = new System.Drawing.Size(75, 23);
            boton_salir.TabIndex = 7;
            boton_salir.Text = "Salir";
            boton_salir.Click += new System.EventHandler(salir);


            AcceptButton = boton_ingresar;
            AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            ClientSize = new System.Drawing.Size(282, 174);
            Controls.Add(boton_ingresar);
            Controls.Add(boton_salir);
            Controls.Add(label_user);
            Controls.Add(label_password);
            Controls.Add(textbox_user);
            Controls.Add(textbox_password);
            MaximizeBox = false;
            Name = "Login";
            StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            Text = "Ingreso al Sistema";
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion
    }
}