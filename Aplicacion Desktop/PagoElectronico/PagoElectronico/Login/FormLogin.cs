using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Text.RegularExpressions;

namespace PagoElectronico.ABM_Rol
{
    public partial class FormLogin : Form
    {
        public FormLogin()
        {
            InitializeComponent();
        }

        private void click_ingresar(object sender, EventArgs e)
        {
            validar_campos(textbox_user.Text, textbox_password.Text);
            
        }

        private void validar_campos(string u, string p)
        {
            if (string.IsNullOrEmpty(u.Trim()) || string.IsNullOrEmpty(p.Trim()))
            {
                //Si se escribieron solamente espacios, los borra

                if(string.IsNullOrEmpty(u.Trim()))
                    textbox_user.Text = string.Empty;
                if (string.IsNullOrEmpty(p.Trim()))
                    textbox_password.Text = string.Empty;

                MessageBox.Show("Debe ingresar un usuario y una contraseña", "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
            else
            {
                //Aca se validan los datos consultando a la base de datos
            }
        }

    

        private void click_salir(object sender, EventArgs e)
        {
            Application.Exit();
        }
    }
}
